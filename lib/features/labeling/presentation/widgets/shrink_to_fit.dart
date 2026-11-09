import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Shows [child] at its full size while it fits the height it is given, and scales it
/// down just enough to fit when it does not, so the content never needs a scroll bar.
///
/// The child is first laid out at the available width. If it is too tall, it is laid
/// out wider by the same factor it is scaled by, so after scaling it still fills the
/// width (wrapped rows such as the fraud types then take fewer lines); the largest
/// scale that fits is searched in a few layouts. Taps, the text cursor and tooltips
/// follow the scale.
///
/// The scale never goes below [minScale]; past it the child is clipped at the bottom
/// instead of painting over what comes below. With an unbounded width or height there
/// is nothing to fit, and the child shows at its full size.
class ShrinkToFit extends SingleChildRenderObjectWidget {
  const ShrinkToFit({
    required Widget super.child,
    this.minScale = 0.4,
    super.key,
  }) : assert(minScale > 0 && minScale <= 1);

  /// The smallest scale, so the text never gets unreadably small.
  final double minScale;

  @override
  RenderShrinkToFit createRenderObject(BuildContext context) =>
      RenderShrinkToFit(minScale);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderShrinkToFit renderObject,
  ) => renderObject.minScale = minScale;
}

class RenderShrinkToFit extends RenderProxyBox {
  RenderShrinkToFit(this._minScale);

  double _minScale;
  double get minScale => _minScale;
  set minScale(double value) {
    if (value == _minScale) return;
    _minScale = value;
    markNeedsLayout();
  }

  /// The scale of the last layout: 1 when the child fits as it is.
  double get scale => _scale;
  double _scale = 1;

  bool _clipped = false;

  final _clipLayer = LayerHandle<ClipRectLayer>();

  Matrix4 get _transform => Matrix4.diagonal3Values(_scale, _scale, 1);

  @override
  void performLayout() {
    final child = this.child;
    _scale = 1;
    _clipped = false;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    if (!width.isFinite || !height.isFinite) {
      child.layout(constraints.loosen(), parentUsesSize: true);
      size = constraints.constrain(child.size);
      return;
    }

    double heightAt(double scale) {
      child.layout(
        BoxConstraints.tightFor(width: width / scale),
        parentUsesSize: true,
      );
      return child.size.height;
    }

    final fullHeight = heightAt(1);
    if (fullHeight > height) {
      // Wider, the child gets shorter (its rows wrap less), so it may need less shrinking
      // than this first guess. Search the largest scale that still fits.
      var low = math.max(height / fullHeight, minScale);
      var high = 1.0;
      for (var i = 0; i < 6 && high - low > 0.005; i++) {
        final middle = (low + high) / 2;
        if (heightAt(middle) * middle <= height) {
          low = middle;
        } else {
          high = middle;
        }
      }
      _scale = low;
      _clipped = heightAt(_scale) * _scale > height;
    }
    size = constraints.constrain(Size(width, child.size.height * _scale));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) return constraints.smallest;
    final width = constraints.maxWidth;
    if (!width.isFinite || !constraints.maxHeight.isFinite) {
      return constraints.constrain(child.getDryLayout(constraints.loosen()));
    }
    // An estimate without the search: the full-width height, capped by the bound.
    final height = child
        .getDryLayout(BoxConstraints.tightFor(width: width))
        .height;
    return constraints.constrain(Size(width, height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    if (_scale == 1) {
      layer = null;
      _clipLayer.layer = null;
      return super.paint(context, offset);
    }
    void paintScaled(PaintingContext context, Offset offset) {
      layer = context.pushTransform(
        needsCompositing,
        offset,
        _transform,
        super.paint,
        oldLayer: layer is TransformLayer ? layer! as TransformLayer : null,
      );
    }

    if (_clipped) {
      _clipLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        Offset.zero & size,
        paintScaled,
        oldLayer: _clipLayer.layer,
      );
    } else {
      _clipLayer.layer = null;
      paintScaled(context, offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) return false;
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (result, position) => child.hitTest(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) =>
      transform.multiply(_transform);

  @override
  void dispose() {
    _clipLayer.layer = null;
    super.dispose();
  }
}

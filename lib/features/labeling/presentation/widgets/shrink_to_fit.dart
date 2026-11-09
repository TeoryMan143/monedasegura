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
/// Needs a bounded height: use it where the parent does not scroll.
class ShrinkToFit extends SingleChildRenderObjectWidget {
  const ShrinkToFit({required Widget super.child, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderShrinkToFit();
}

class _RenderShrinkToFit extends RenderProxyBox {
  double _scale = 1;

  Matrix4 get _transform => Matrix4.diagonal3Values(_scale, _scale, 1);

  @override
  void performLayout() {
    final child = this.child!;
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    child.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
    _scale = 1;
    if (height.isFinite && child.size.height > height) {
      // Laid out wider, the child gets shorter (its rows wrap less), so it may need less
      // shrinking than this first guess. Search the largest scale that still fits.
      bool fits(double scale) {
        child.layout(
          BoxConstraints.tightFor(width: width / scale),
          parentUsesSize: true,
        );
        return child.size.height * scale <= height;
      }

      var low =
          height / child.size.height; // Fits: wider never makes it taller.
      var high = 1.0; // Does not fit.
      for (var i = 0; i < 6 && high - low > 0.005; i++) {
        final middle = (low + high) / 2;
        fits(middle) ? low = middle : high = middle;
      }
      _scale = low;
      fits(_scale);
    }
    size = constraints.constrain(Size(width, child.size.height * _scale));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_scale == 1) return super.paint(context, offset);
    layer = context.pushTransform(
      needsCompositing,
      offset,
      _transform,
      super.paint,
      oldLayer: layer is TransformLayer ? layer! as TransformLayer : null,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      result.addWithPaintTransform(
        transform: _transform,
        position: position,
        hitTest: (result, position) =>
            child!.hitTest(result, position: position),
      );

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) =>
      transform.multiply(_transform);
}

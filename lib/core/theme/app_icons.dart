/// The functional line icon set (DESIGN.md · Icons).
///
/// 24×24 grid, 1.5 px uniform stroke, angular corners and straight ends, no fills. Each
/// value points to an SVG in `assets/icons/`. Render them with the `AppIcon` widget of
/// `core/ui`, never with Material `Icons`.
///
/// The SVGs were drawn following the brand manual *Iconografía* rules. When the Figma
/// *Iconografía* grid is exported, replace the files keeping the same names.
enum AppIcons {
  // Navigation and actions.
  home('home'), // Inicio
  menu('menu'), // Menú
  search('search'), // Buscar
  bell('bell'), // Campana
  user('user'), // Usuario
  logout('logout'), // Salir
  close('close'), // Cerrar
  check('check'), // Check
  plus('plus'), // Más
  minus('minus'), // Indeterminate checkbox
  chevronDown('chevron_down'),
  chevronUp('chevron_up'),
  chevronLeft('chevron_left'),
  chevronRight('chevron_right'),
  arrowUp('arrow_up'), // Ascending sort
  arrowDown('arrow_down'), // Descending sort
  filter('filter'), // Filtro
  sort('sort'), // Ordenar
  moreOptions('more_options'), // Más opciones
  list('list'), // Lista
  edit('edit'), // Editar
  refresh('refresh'), // Refrescar
  download('download'), // Descargar
  externalLink('external_link'), // Enlace externo
  sidePanel('side_panel'), // Panel lateral
  keyboard('keyboard'), // Teclado
  loading('loading'), // Cargando
  // Domain.
  ai('ai'), // IA (sparkle)
  statistics('statistics'), // Estadísticas
  calendar('calendar'), // Calendario
  clock('clock'), // Reloj
  audit('audit'), // Auditoría
  inbox('inbox'), // Bandeja
  eye('eye'), // Ojo
  eyeOff('eye_off'), // Ojo tachado (hide password)
  location('location'), // Ubicación
  timeline('timeline'), // Línea de tiempo
  document('document'), // Documento
  info('info'), // Info
  warning('warning'), // Advertencia
  error('error'), // Error (circle ×)
  shield('shield'), // Escudo (brand mark)
  device('device'), // Dispositivo
  card('card'), // Tarjeta
  bank('bank'), // Banco
  transfer('transfer'), // Transferencia
  signal('signal'), // Señal
  trendUp('trend_up'), // Tendencia arriba
  trendDown('trend_down'), // Tendencia abajo
  currency('currency'), // Moneda
  comment('comment'), // Comentario
  lock('lock'), // Bloqueo
  mail('mail'); // Correo

  const AppIcons(this.fileName);

  /// File name in `assets/icons/`, without extension.
  final String fileName;

  /// Asset path of the SVG.
  String get asset => 'assets/icons/$fileName.svg';
}

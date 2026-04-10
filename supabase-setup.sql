-- ═══ Prisimic Content Hub — Supabase Schema ═══

-- Tabla de piezas de contenido
CREATE TABLE content_pieces (
  id SERIAL PRIMARY KEY,
  pilar TEXT NOT NULL CHECK (pilar IN ('look', 'street', 'stitch', 'comm')),
  channel TEXT NOT NULL,
  format TEXT NOT NULL,
  title TEXT NOT NULL,
  copy TEXT NOT NULL,
  note TEXT,
  scheduled_date DATE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Tabla de comentarios
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  piece_id INTEGER NOT NULL REFERENCES content_pieces(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('comment', 'suggestion')),
  text TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Contador de ediciones
CREATE TABLE metadata (
  key TEXT PRIMARY KEY,
  value INTEGER DEFAULT 0
);
INSERT INTO metadata (key, value) VALUES ('edits', 0);

-- Tabla de canales
CREATE TABLE channels (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Tabla de formatos
CREATE TABLE formats (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Habilitar RLS (Row Level Security)
ALTER TABLE content_pieces ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE channels ENABLE ROW LEVEL SECURITY;
ALTER TABLE formats ENABLE ROW LEVEL SECURITY;

-- Políticas: acceso público con anon key (para un hub de equipo)
CREATE POLICY "allow_all_content" ON content_pieces FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_comments" ON comments FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_metadata" ON metadata FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_channels" ON channels FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_formats" ON formats FOR ALL USING (true) WITH CHECK (true);

-- Seed: canales iniciales
INSERT INTO channels (name) VALUES ('Instagram'), ('TikTok'), ('Website/Blog'), ('Email'), ('YouTube');

-- Seed: formatos iniciales
INSERT INTO formats (name) VALUES ('Post'), ('Carrusel'), ('Story'), ('Video'), ('UGC Repost'), ('Artículo'), ('Newsletter'), ('Vlog');

-- Seed: contenido inicial
INSERT INTO content_pieces (id, pilar, channel, format, title, copy, note, scheduled_date) VALUES
(1, 'look', 'Instagram', 'Carrusel', 'Essentials que nunca pasan de moda',
 E'Hay prendas que trascienden temporadas. Remera blanca oversize, jeans rectos, blazer negro: el trío que no falla.\n\nSwipeá para ver cómo combinarlos en 5 looks distintos — del lunes casual al viernes de noche.\n\n#Prisimic #Essentials #ModaConsciente',
 'Carrusel de 5 slides. Fondo neutro beige, tipografía serif grande en cada slide. Última slide con CTA a la tienda.',
 '2026-04-21'),

(2, 'street', 'TikTok', 'Video', 'POV: armás un outfit en 60 seg',
 E'POV: tenés 60 segundos para armar el outfit perfecto con solo 4 prendas Prisimic.\n\nTimer en pantalla. Fast cuts. Beat drop en el reveal final.\n\nNo necesitás más. Necesitás las prendas correctas.',
 'Video vertical 9:16. Usar timer real en pantalla. Música trending con beat drop. Quick cuts en la selección, slow-mo en el reveal.',
 '2026-04-14'),

(3, 'stitch', 'Instagram', 'Story', 'Cómo elegimos nuestras telas',
 E'No toda tela es igual.\n\nCada prenda Prisimic empieza con una decisión: ¿cómo se va a sentir esto puesto?\n\nHoy te mostramos el proceso de selección en nuestro taller — desde la muestra hasta la pieza final.',
 'Secuencia de 4-5 stories. Fotos close-up de telas, manos tocando texturas, etiquetas. Estética raw, sin filtros pesados. Texto mínimo.',
 '2026-04-23'),

(4, 'comm', 'Instagram', 'UGC Repost', 'Tu outfit Prisimic del día',
 E'Nada nos gusta más que ver cómo hacen suyas nuestras prendas.\n\n@usuario nos muestra que un básico Prisimic puede ser todo menos básico.\n\n¿Querés aparecer? Taggeanos con #PrismicStyle.',
 'Repost de UGC con marco de marca sutil. Agregar tag del usuario y hashtag. Stories con sticker de pregunta para fomentar más UGC.',
 '2026-04-29'),

(5, 'street', 'TikTok', 'Video', 'Tendencias urbanas: lo que viene',
 E'Lo que ves en la calle hoy, lo vas a ver en todos lados en 6 meses.\n\nEsta semana salimos a capturar los looks que nos llamaron la atención en Palermo y Villa Crespo.\n\nLo urbano no se diseña — se observa.',
 'Estilo documental. Cámara en mano, street footage real. Texto overlay con tipografía bold. Cerrar con prendas Prisimic que matchean las tendencias.',
 '2026-04-24'),

(6, 'stitch', 'Instagram', 'Carrusel', 'El proceso detrás del nuevo drop',
 E'Spoiler: una colección no nace en un día.\n\n6 meses de bocetos, pruebas de tela, fittings y decisiones difíciles.\n\nAbrimos el proceso del drop que se viene — desde la idea hasta el perchero.',
 'Carrusel 8 slides: boceto > tela > corte > costura > fitting > foto > packaging > perchero. Fotos reales del taller.',
 '2026-05-05'),

(7, 'comm', 'TikTok', 'Video', 'Outfit check: nuestro equipo',
 E'¿Qué usa el equipo Prisimic un martes random?\n\nSpoiler: mucho negro, algún color inesperado, y al menos una pieza vintage.\n\nOutfit check del equipo — sin filtro, sin producción.',
 'Formato trending de outfit check. Cada persona del equipo hace un spin. Texto con nombre y rol. Casual, divertido.',
 '2026-04-30'),

(8, 'look', 'Website/Blog', 'Artículo', 'Guía de estilo: oversize vs fitted',
 E'El debate eterno: ¿oversize o fitted?\n\nLa respuesta es más simple de lo que pensás: depende de qué querés comunicar.\n\nEn esta guía te mostramos cuándo usar cada silueta, cómo combinarlas, y por qué el fit es la decisión más importante de tu outfit.\n\nIncluye lookbook con prendas de la colección actual.',
 'Artículo largo para blog. Incluir galería de imágenes con ambos estilos. SEO: targeting "oversize vs fitted" y "guía de estilo hombre/mujer".',
 '2026-04-28'),

(9, 'street', 'Instagram', 'Post', 'Prisimic x Street: collab reveal',
 E'Algo nuevo está por salir.\n\nColaboramos con artistas locales para una cápsula que cruza moda y arte urbano.\n\n3 piezas. Edición limitada. Fecha: próximamente.\n\nActivá las notificaciones para no perdértelo.',
 'Imagen teaser con siluetas oscuras de las prendas. Tipografía grande. Posteado como single image, no carrusel. Crear expectativa.',
 '2026-04-28'),

(10, 'stitch', 'TikTok', 'Video', 'De la tela al perchero',
 E'Vas a ver cómo una pieza de tela se convierte en tu próxima prenda favorita.\n\nTimelapse de 60 segundos: desde el corte hasta el planchado final.\n\nCada puntada tiene intención.',
 'Timelapse del proceso completo en el taller. Música ambient/instrumental. Sin voiceover, dejar que el proceso hable. Texto mínimo al final.',
 '2026-05-01'),

(11, 'look', 'Email', 'Newsletter', 'Los más vendidos de la semana',
 E'Lo que más eligieron esta semana:\n\n1. Remera Essential — el básico que todos necesitan\n2. Cargo pant — comodidad y estilo\n3. Hoodie oversize — el favorito de siempre\n\nCada pieza fue pensada para durar más que una temporada.\n\n→ Ver colección completa',
 'Newsletter semanal. Layout limpio con fotos de producto. CTA principal a la tienda. Incluir sección "Nuevo esta semana" al final.',
 '2026-04-17'),

(12, 'comm', 'Instagram', 'Story', 'Compartí tu look #PrismicStyle',
 E'¿Cómo combinás tus prendas Prisimic?\n\nCompartí tu look en stories, taggeanos y usá #PrismicStyle.\n\nVamos a repostear nuestros favoritos toda la semana.\n\nTu estilo, nuestra comunidad.',
 'Story con sticker de subida de foto. Background con collage de looks anteriores de la comunidad. Incluir highlight permanente "Community".',
 '2026-05-07'),

(13, 'look', 'Instagram', 'Post', 'Lanzamiento nueva colección',
 E'La nueva colección ya está acá.\n\n12 piezas que resumen todo lo que creemos: siluetas limpias, materiales nobles, diseño que dura.\n\nDisponible ahora en prisimic.com y en nuestro showroom.\n\nColección FORMA — primavera 2026.',
 'Post hero con foto de campaña principal. Imagen editorial de alta calidad. Complementar con carrusel de producto al día siguiente.',
 '2026-04-15'),

(14, 'street', 'Website/Blog', 'Artículo', 'El básico perfecto existe',
 E'Pasamos un año entero perfeccionando una remera.\n\nEl cuello, el largo, el gramaje de la tela, la caída del hombro — cada detalle fue testeado, descartado, y vuelto a probar.\n\nEsta es la historia de cómo llegamos al básico perfecto.\n\nY por qué creemos que menos siempre es más.',
 'Artículo narrativo para el blog. Incluir fotos comparativas de prototipos vs versión final. Tono personal, casi de manifiesto.',
 '2026-04-16');

-- Reset sequence para que nuevos inserts no colisionen
SELECT setval('content_pieces_id_seq', 14);

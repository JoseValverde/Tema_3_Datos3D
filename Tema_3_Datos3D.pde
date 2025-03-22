import processing.data.*;

// Constantes para los colores
final color C001 = color(255, 255, 255); // Blanco
final color C002 = color(0, 0, 0); // Negro
final color C003 = color(255, 0, 0); // Rojo
final color C004 = color(100, 100, 100); // Gris

// Tabla para almacenar los datos del CSV
Table table;

// Variables para la animación
int currentYearIndex = 0;
int totalYears;
String[] uniqueYears;
float timer = 0; // Temporizador para controlar el cambio de año
float yearDuration = 1; // Duración de cada año en segundos
long lastMillis = 0; // Nueva variable para almacenar el tiempo del frame anterior

PFont Pixel_Regular;

void settings() {
  size(720, 1024, P3D);
  smooth();
}

void setup() {
  surface.setLocation(1000, 20);
  background(C002);
  frameRate(30);

  // Cargar el archivo CSV
  table = loadTable("Civil_liberties_index.csv", "header");

  // Obtener los años únicos
  uniqueYears = getUniqueYears();
  totalYears = uniqueYears.length;
  lastMillis = millis(); // Inicializar el tiempo del frame anterior

  Pixel_Regular = createFont("10Pixel_Regular.ttf", 600);
  textFont(Pixel_Regular);
}

void draw() {
  background(C002);
  /*
  // En lugar de lights(), usa esto
  ambientLight(50, 50, 50);  // Luz ambiental suave (RGB)

  // Luz direccional principal (simula el sol)
  directionalLight(255, 250, 200,  // Color amarillento (RGB)
                   -1, -0.5, -0.2);  // Dirección (vector normalizado)
*/
  // Luz puntual (como una bombilla)
  pointLight(200, 200, 255,  // Color azulado (RGB)
             width/2, height/2 - 200, 100);  // Posición (x, y, z)

  // Opción 1: Ajustar el punto al que mira la cámara
camera(
  width/2, height/2-200, 1000,          // Posición de la cámara
  width/2, height/2-200, -200,         // Punto al que mira (ahora coincide con la traslación)
  0, 1, 0                          // Vector "arriba"
);

  translate(width/2, height/2, -200); // Centra la escena y la aleja



  // Calcular deltaTime correctamente
  long currentMillis = millis();
  float deltaTime = currentMillis - lastMillis;
  lastMillis = currentMillis;

  // Control del tiempo
  timer += deltaTime / 100.0; // deltaTime es el tiempo en milisegundos desde el último frame
  if (timer >= yearDuration) {
    timer = 0;
    currentYearIndex++;
    if (currentYearIndex >= totalYears) {
      currentYearIndex = 0; // Reiniciar la animación
    }
  }

  // Mostrar el año actual
  String currentYear = uniqueYears[currentYearIndex];
  fill(C001); // Color blanco para el texto
  textSize(420);
  textAlign( TOP);
  text(currentYear, -width/2-100, -height/2+180, 0); // Mostrar el año en la esquina superior izquierda

  // Mostrar los datos para el año actual
  showDataForYear(currentYear);
}

// Función para mostrar los datos de un año específico
void showDataForYear(String year) {
  for (TableRow row : table.rows()) {
    String zone = row.getString("Pais");
    String rowYear = row.getString("year");
    float index = row.getFloat("Civil liberties index (best estimate, aggregate: average)");

    if (rowYear.equals(year)) {
      // Visualización 3D (ejemplo: cubos)
      pushMatrix();
      float x = map(zone.hashCode() % 100, 0, 100, -250, 250); // Posición x basada en el nombre de la zona
      float y = map(index, 0, 10, -200, 200); // Posición y basada en el índice
      translate(x, y, 0);
      fill(C003); // Color basado en el índice
      box(40, 40, 40); // Dibuja un cubo

      // Mostrar el nombre de la zona y el índice
      fill(C001); // Color blanco para el texto
      textSize(20);
      text(zone + ": " + index, 0, -30); // Mostrar el nombre y el índice encima del cubo
      popMatrix();
    }
  }
}

// Función para obtener los años únicos del CSV
String[] getUniqueYears() {
  StringList years = new StringList();
  for (TableRow row : table.rows()) {
    String year = row.getString("year");
    if (!years.hasValue(year)) {
      years.append(year);
    }
  }
  years.sort();
  return years.array();
}

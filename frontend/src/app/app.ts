import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({ //indica que la clase es un componente y proporciona su configuracion
  imports: [RouterOutlet], // permite importar componentes, directivas
  // y pipes que utiliza la plantilla en componentes standalone.
  selector: 'app-root', // identifica el elemento HTML asociado al componente.
  styleUrl: './app.css', // indica dónde están sus estilos.
  templateUrl: './app.html', // indica dónde está su plantilla.
})
export class App {
  titulo = 'Mi aplicación Angular';
}

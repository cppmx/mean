import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from './api.service';

import { NgbPaginationModule, NgbAlertModule } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, NgbPaginationModule, NgbAlertModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  connectionStatus: string = 'Desconocido';
  connectionString: string = 'Desconocido';
  newItem: string = '';
  items: { _id?: string, text: string, date: string }[] = [];
  dbActive: boolean = false;

  constructor(private myBackendService: ApiService) { 
    this.myBackendService.dbGetAll().subscribe({
      next: (response) => {
        this.items = response.data;

        if(this.items.length > 0) {
          this.connectionStatus = 'Datos iniciales cargados desde la BD!';
          this.dbActive = true;
        } else {
          this.connectionStatus = 'Aún sin conexión!';
        }
      },
      error: () => {
        this.connectionStatus = 'Aún sin conexión!';
      }
    });
  }

  testDbConnection() {
    this.myBackendService.testDbConnection().subscribe({
      complete: () => {
        this.connectionStatus = 'Conexión exitosa a la base de datos';
        this.dbActive = true;
        console.debug("Conexión a la BD exitosa")
      },
      error: () => {
        this.dbActive = false;
        this.connectionStatus = 'Error al conectar a la base de datos';
        console.error("Conexión a la BD fallida!")
      }
    });

    this.myBackendService.getDBString().subscribe({
      next: (response) => {
        this.connectionString = response.data;
        console.debug("Se obtuvo el string de conexión a la BD.")
      },
      error: () => {
        console.error("Conexión a la BD fallida al momento de obtener el string de conexión!")
      }
    });
  }

  insertItem() {
    if (this.dbActive) {
      // Obtén la fecha y hora actual
      const currentDate = new Date();
      const formattedDate = currentDate.toISOString();
      const item: { _id?: string, text: string, date: string } = { text: this.newItem, date: formattedDate };

      this.myBackendService.addItem(item).subscribe({
        next: (response) => {
          // Verifica si hay un _id en la respuesta
          if (response?.data?.insertedId) {
            // Asigna el _id generado a la propiedad id del item
            item._id = response.data.insertedId;
          }

          this.connectionStatus = 'El dato ha sido agregado a la BD con éxito';
          this.items.push(item);
        },
        error: () => {
          this.connectionStatus = 'Hubo un error al intentar enviar los datos a la BD.';
        }
      });

      // Limpiar el campo después de la inserción
      this.newItem = '';
    }
  }

  eliminarItem(item: { _id?: string, text: string, date: string }) {
    if (this.dbActive && item._id) {
      this.myBackendService.deleteItem(item._id).subscribe({
        complete: () => {
          const index = this.items.indexOf(item);

          if (index !== -1) {
            this.items.splice(index, 1);
          }

          this.connectionStatus = 'El elemnto seleccionado ha sido eliminado de la BD exitósamente.';
        },
        error: () => {
          this.connectionStatus = 'Hubo un error al intentar enviar los datos a la BD.';
        }
      });
    }
  }
}

import { Component, OnInit } from '@angular/core';
import { Router, RouterOutlet } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatButtonModule } from '@angular/material/button';
import { MatListModule } from '@angular/material/list';
import { RouterModule } from '@angular/router';
import { MatSelectModule } from '@angular/material/select';
import { MatTableModule } from '@angular/material/table';
import { MatDividerModule } from '@angular/material/divider';
import { NgIf } from '@angular/common';
import { MatMenuModule } from '@angular/material/menu';
import { Auth, signOut, onAuthStateChanged, User } from '@angular/fire/auth';


@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    MatToolbarModule,
    MatIconModule,
    MatSidenavModule,
    MatButtonModule,
    MatListModule,
    RouterModule,
    MatSelectModule,
    MatTableModule,
    MatDividerModule,
    NgIf,
    MatMenuModule,


    
    
  ],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  logIN: boolean = false; // État de connexion
  userEmail: string | null = null; // Variable pour stocker l'email de l'utilisateur
  title = 'baikasugu';

  constructor(private auth: Auth, private router: Router) {}

  ngOnInit(): void {
    // Durée de session en millisecondes (10 secondes pour tester)
    const sessionDuration = 3600000
    let sessionStartTime = localStorage.getItem('sessionStartTime');
    
    onAuthStateChanged(this.auth, (user: User | null) => {
      if (user) {
        const currentTime = new Date().getTime();
        console.log('Utilisateur connecté :', user.email);
        console.log('Temps actuel :', currentTime);

        // Si la session n'a pas été démarrée, démarrer une nouvelle session
        if (!sessionStartTime) {
          sessionStartTime = currentTime.toString();
          console.log('Stockage de la nouvelle heure de début de session :', sessionStartTime);
          localStorage.setItem('sessionStartTime', sessionStartTime);
        }

        this.logIN = true;
        this.userEmail = user.email; // Récupérer l'email de l'utilisateur connecté
        this.router.navigate(['/dashboard']); // Rediriger vers le dashboard

        // Vérifier toutes les secondes si la session a expiré
        const intervalId = setInterval(() => {
          const currentTimeInterval = new Date().getTime();
          const storedStartTime = localStorage.getItem('sessionStartTime');

          if (storedStartTime && (currentTimeInterval - Number(storedStartTime)) > sessionDuration) {
            console.log('Session expirée après 10 secondes. Déconnexion...');
            clearInterval(intervalId); // Arrêter l'intervalle après la déconnexion
            this.logout(); // Déconnexion
          }
        }, 1000); // Vérifie toutes les secondes
      } else {
        // Aucun utilisateur connecté
        this.logIN = false;
        this.userEmail = null;
        this.router.navigate(['/login']); // Rediriger vers login
      }
    });
  }

  // Fonction pour déconnecter l'utilisateur
  logout(): void {
    signOut(this.auth).then(() => {
      this.logIN = false;
      this.userEmail = null; // Réinitialiser l'email lors de la déconnexion
      localStorage.removeItem('sessionStartTime'); // Supprimer l'heure de début de session
      console.log('Utilisateur déconnecté. Redirection vers login.');
      this.router.navigate(['/login']);
    }).catch((error) => {
      console.error('Erreur lors de la déconnexion :', error);
    });
  }

  
  
  
}

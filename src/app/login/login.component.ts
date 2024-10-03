import {Component} from '@angular/core';
import { Auth, signInWithEmailAndPassword } from '@angular/fire/auth';
import { inject } from '@angular/core';
import { Router, RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule,
    RouterModule,
  ],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  
  email: string = '';
  password: string = '';
  
  private auth: Auth = inject(Auth);
  private router: Router = inject(Router);

  // Function to handle login 
  login() {
    if (this.email && this.password) {
      signInWithEmailAndPassword(this.auth, this.email, this.password)
        .then(userCredential => {
          // Login successful
          console.log('User logged in:', userCredential.user);
          this.router.navigate(['/produits']);
        })
        .catch(error => {
          // Handle login error
          console.error('Login error:', error.message);
        });
    }
  }

}

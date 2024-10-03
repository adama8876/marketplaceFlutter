// src/app/models/product.model.ts
export interface Product {
    id?: string;          // Optionnel, car Firestore génère l'ID automatiquement
    nom: string;
    description: string;
    prix: number;
    quantité: number;
    dateDeCreation: Date;
    imageURL: string;
    categorie: string;
    sousCategorie?: string;
    createurId: string;    // L'ID de l'utilisateur (admin ou vendeur)
    createurNom: string;   // L'email ou le nom de l'utilisateur
    // roleCreateur: string; 
  }
  
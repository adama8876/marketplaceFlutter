
export interface Category {
    id?: string;              // ID optionnel, généré automatiquement par Firestore
    nom: string;              // Nom de la catégorie
    imageURL: string;         // URL de l'image de la catégorie
    dateDeCreation: Date;     // Date de création de la catégorie
  }
  
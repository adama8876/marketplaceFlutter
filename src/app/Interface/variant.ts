export interface Variant {
    id: string;
    nom: string;
    variantTypeId: string;
    createdAt: any; // Ou 'Date' si tu convertis Firestore Timestamps en objets Date
  }
  
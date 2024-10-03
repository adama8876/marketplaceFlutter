import { Injectable } from '@angular/core';
import { Firestore, collection, addDoc, DocumentReference, DocumentData, updateDoc, deleteDoc, doc, collectionData } from '@angular/fire/firestore';
import { Storage, ref, uploadBytes, getDownloadURL } from '@angular/fire/storage';
import { Auth } from '@angular/fire/auth';
import { getDocs } from 'firebase/firestore';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ProductService {

  constructor(private firestore: Firestore, private storage: Storage, private auth: Auth) { }

  // Méthode pour uploader une image dans Firebase Storage et retourner son URL
  async uploadImage(file: File, path: string): Promise<string> {
    const imageRef = ref(this.storage, `${path}/${file.name}`);
    const snapshot = await uploadBytes(imageRef, file);
    return getDownloadURL(snapshot.ref);
  }

  // Méthode pour ajouter un produit avec des images
  async addProduct(
    productName: string,
    price: number,
    quantity: number,
    description: string,
    categoryId: string,
    subcategoryId: string,
    mainImageUrl: string,
    secondImageUrl?: string | null,  // Peut être undefined ou null
    thirdImageUrl?: string | null,   // Peut être undefined ou null
    fourthImageUrl?: string | null,  // Peut être undefined ou null
    variantData: any[] = []
  ): Promise<DocumentReference<DocumentData>> { // Modification du type de retour
    const user = this.auth.currentUser;
    if (!user) {
      throw new Error("L'utilisateur doit être connecté pour ajouter un produit.");
    }

    // Construction de l'objet produit à ajouter dans Firestore
    const productData = {
      name: productName,
      price: price,
      quantity: quantity,
      description: description,
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      mainImageUrl: mainImageUrl,
      secondImageUrl: secondImageUrl || null,  // Si non défini, sera null
      thirdImageUrl: thirdImageUrl || null,    // Si non défini, sera null
      fourthImageUrl: fourthImageUrl || null,  // Si non défini, sera null
      variantData: variantData,                // Variantes associées au produit
      addedBy: user.uid,                       // ID de l'utilisateur connecté
      createdAt: new Date()                    // Date de création du produit
    };

    const productsRef = collection(this.firestore, 'products'); // Référence à la collection Firestore
    return addDoc(productsRef, productData); // Ajout du produit dans Firestore
  }




   // Méthode pour récupérer tous les produits
   getProducts(): Observable<any[]> {
    const productsRef = collection(this.firestore, 'products');
    return collectionData(productsRef, { idField: 'id' }) as Observable<any[]>;
  }





  async updateProduct(
    productId: string,
    productData: {
      productName?: string;
      price?: number;
      quantity?: number;
      description?: string;
      categoryId?: string;  // Ajoutez categoryId ici
      subcategoryId?: string;
      mainImageUrl?: string | null;
      secondImageUrl?: string | null;
      thirdImageUrl?: string | null;
      fourthImageUrl?: string | null;
      variantData?: any[];
    }
  ): Promise<void> {
    const productDocRef = doc(this.firestore, `products/${productId}`);
    return updateDoc(productDocRef, {
      name: productData.productName,
      price: productData.price,
      quantity: productData.quantity,
      description: productData.description,
      categoryId: productData.categoryId,  // Incluez categoryId dans les données
      subcategoryId: productData.subcategoryId,
      mainImageUrl: productData.mainImageUrl,
      secondImageUrl: productData.secondImageUrl || null,
      thirdImageUrl: productData.thirdImageUrl || null,
      fourthImageUrl: productData.fourthImageUrl || null,
      variantData: productData.variantData || []
    });
  }
  
  

  // Méthode pour supprimer un produit
  async deleteProduct(productId: string): Promise<void> {
    const productDocRef = doc(this.firestore, `products/${productId}`);
    return deleteDoc(productDocRef);
  }
}

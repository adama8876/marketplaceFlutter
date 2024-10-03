import { Component, OnInit } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
// import { Component, OnInit, AfterViewInit } from '@angular/core';
// import { ProduitService } from '../Services/produit.service';
import { NgFor, NgIf } from '@angular/common';
import { MatPaginator } from '@angular/material/paginator';
import { MatSnackBar } from '@angular/material/snack-bar';
import { DomSanitizer } from '@angular/platform-browser';
import { ProductDialogComponent } from '../dialog/product-dialog/product-dialog.component';
import { ProductService } from '../Services/prouct.service';
import { CategoryService } from '../Services/category.service';
import { SubcategoryService } from '../Services/souscategory.service';
import { VariantTypeService } from '../Services/variant-type.service';
import { FormsModule } from '@angular/forms';
import { Observable } from 'rxjs';
// import { MatTableDataSource } from '@angular/material/table';  // Po

@Component({
  selector: 'app-produits',
  standalone: true,
  imports: [ MatIconModule,
    MatButtonModule,
    MatTableModule,
    MatDialogModule,
    MatPaginator,
    FormsModule,
    // Observable,
  
    NgFor,
    NgIf],
  templateUrl: './produits.component.html',
  styleUrl: './produits.component.css'
})
export class ProduitsComponent implements OnInit  {
filterelement($event: Event) {
throw new Error('Method not implemented.');
}

displayedColumns: string[] = ['id', 'image', 'name', 'price', 'quantity', 'description', 'subCategory', 'action'];
dataSource = new MatTableDataSource<any>([]); // Utilisation de MatTableDataSource pour les données

constructor(
  private dialog: MatDialog,  // Injecter MatDialog pour ouvrir le formulaire
  private productService: ProductService,
  private categoryService: CategoryService,
  private subcategoryService: SubcategoryService,
  private snackBar: MatSnackBar,
  private variantTypeService: VariantTypeService
) {}

// Méthode pour ouvrir le formulaire dans un dialog
openAddProductDialog(): void {
  const dialogRef = this.dialog.open(ProductDialogComponent, {
    width: '1000px',
    height: '600px',
    maxWidth: '90vw',
  });

  dialogRef.afterClosed().subscribe(result => {
    if (result) {
      this.loadProducts(); // Recharger la liste des produits après ajout
    }
  });
}


 // Méthode pour charger les produits
 loadProducts(): void {
  this.productService.getProducts().subscribe(products => {
    this.dataSource.data = products;
    console.log('Produits chargés :', products);
  }, error => {
    console.error('Erreur lors du chargement des produits :', error);
    this.snackBar.open('Erreur lors du chargement des produits', 'Fermer', { duration: 3000 });
  });
}


ngOnInit(): void {
  this.loadProducts(); // Charger les produits au démarrage

}

// Méthode pour supprimer un produit
deleteProduct(productId: string): void {
  this.productService.deleteProduct(productId).then(() => {
    this.snackBar.open('Produit supprimé avec succès', 'Fermer', { duration: 3000 });
    this.loadProducts(); // Recharger la liste des produits après suppression
  }).catch(error => {
    console.error('Erreur lors de la suppression du produit :', error);
    this.snackBar.open('Erreur lors de la suppression du produit', 'Fermer', { duration: 3000 });
  });
}

// // Méthode pour filtrer la liste des produits (à implémenter si nécessaire)
// filterelement($event: Event) {
//   const filterValue = ($event.target as HTMLInputElement).value;
//   // Implémenter le filtre ici
//   console.log('Filtrer avec :', filterValue);




openEditProductDialog(product: any): void {
  const dialogRef = this.dialog.open(ProductDialogComponent, {
    width: '1000px',
    height: '600px',
    maxWidth: '90vw',
    data: { product } // Passez le produit à modifier dans le dialogue
  });

  dialogRef.afterClosed().subscribe(updatedProductData => {
    if (updatedProductData) {
      // Préparez les données mises à jour, en incluant 'categoryId'
      const {
        productName,
        price,
        quantity,
        description,
        category, // Inclure la catégorie
        subCategory, // Ceci est l'ID de la sous-catégorie
        mainImageUrl,
        secondImageUrl,
        thirdImageUrl,
        fourthImageUrl,
        variantItem // Les données des variantes mises à jour
      } = updatedProductData;

      // Appelle la méthode updateProduct du service
      this.productService.updateProduct(product.id, {
        productName,
        price,
        quantity,
        description,
        categoryId: category, // Inclure l'ID de la catégorie
        subcategoryId: subCategory, // Utiliser uniquement l'ID de la sous-catégorie
        mainImageUrl: mainImageUrl || null,
        secondImageUrl: secondImageUrl || null,
        thirdImageUrl: thirdImageUrl || null,
        fourthImageUrl: fourthImageUrl || null,
        variantData: variantItem || []
      })
      .then(() => {
        console.log('Produit mis à jour avec succès');
        this.loadProducts(); // Rechargez la liste des produits après la mise à jour
      })
      .catch(error => {
        console.error('Erreur lors de la mise à jour du produit :', error);
        this.snackBar.open('Erreur lors de la mise à jour du produit', 'Fermer', { duration: 3000 });
      });
    }
  });
}







}
 
  























// productName: string = '';
// price: number = 0;
// quantity: number = 0;
// description: string = '';
// categoryId: string = '';
// subcategoryId: string = '';
// mainImage: File | null = null;
// secondImage: File | null = null;
// thirdImage: File | null = null;
// fourthImage: File | null = null;
// selectedVariants: string[] = [];
// variantTypeId: string = '';
// variantTypes: any[] = [];
// categories: any[] = [];
// subcategories: any[] = [];
// variants: any[] = [];

// constructor(
//   private productService: ProductService,
//   private categoryService: CategoryService,
//   private subcategoryService: SubcategoryService,
//   private variantTypeService: VariantTypeService,
//   private dialog: MatDialog,
// ) {}

// ngOnInit(): void {
//   // Charger les catégories et types de variantes
//   this.categoryService.getCategoriesWithImages().then((categories) => {
//     this.categories = categories;
//     console.log('Catégories chargées:', this.categories);
//   });

  
//   this.variantTypeService.getVariantTypes().subscribe((variantTypes) => {
//     this.variantTypes = variantTypes;
//     console.log('Variantes-types chargées:', this.variantTypes); // Vérification des données
//   });
// }

// // Charger les sous-catégories en fonction de la catégorie sélectionnée
// onCategoryChange(): void {
//   console.log('Catégorie sélectionnée:', this.categoryId);
//   this.subcategoryService.getAllSubcategories().then((subcategories) => {
//     console.log('Toutes les sous-catégories récupérées:', subcategories);
//     subcategories.forEach(sub => console.log(`Sous-catégorie: ${sub.nom}, Category ID: ${sub.categorieId}`));
//     this.subcategories = subcategories.filter(sub => sub.categorieId === this.categoryId); // Utilisation de categorieId
//     console.log('Sous-catégories filtrées:', this.subcategories);
    
//     if (this.subcategories.length === 0) {
//       console.warn('Aucune sous-catégorie disponible pour cette catégorie.');
//     }
//   }).catch(error => {
//     console.error('Erreur lors de la récupération des sous-catégories:', error);
//   });
// }

// // Charger les variantes en fonction du type de variante sélectionné
// onVariantTypeChange(): void {
//   console.log('Type de variante sélectionné:', this.variantTypeId);
//   this.variantTypeService.getVariants().subscribe((variants) => {
//     console.log('Toutes les variantes récupérées:', variants);
//     this.variants = variants.filter(variant => variant.variantTypeId === this.variantTypeId);
//     console.log('Variantes filtrées:', this.variants);

//     if (this.variants.length === 0) {
//       console.warn('Aucune variante disponible pour ce type de variante.');
//     }
//   }, error => {
//     console.error('Erreur lors de la récupération des variantes:', error);
//   });
// }


// // Méthode pour gérer la sélection des variantes avec les cases à cocher
// onVariantCheckboxChange(event: any, variantId: string): void {
//   if (event.target.checked) {
//     this.selectedVariants.push(variantId);
//   } else {
//     this.selectedVariants = this.selectedVariants.filter(id => id !== variantId);
//   }
//   console.log('Variantes sélectionnées:', this.selectedVariants);
// }

// // Méthode pour gérer la sélection de l'image principale
// onMainImageSelected(event: any): void {
//   this.mainImage = event.target.files[0];
//   console.log('Image principale sélectionnée:', this.mainImage);
// }

// // Méthode pour gérer la sélection de la deuxième image (optionnelle)
// onSecondImageSelected(event: any): void {
//   this.secondImage = event.target.files[0] || null;
//   console.log('Deuxième image sélectionnée:', this.secondImage);
// }

// // Méthode pour gérer la sélection de la troisième image (optionnelle)
// onThirdImageSelected(event: any): void {
//   this.thirdImage = event.target.files[0] || null;
//   console.log('Troisième image sélectionnée:', this.thirdImage);
// }

// // Méthode pour gérer la sélection de la quatrième image (optionnelle)
// onFourthImageSelected(event: any): void {
//   this.fourthImage = event.target.files[0] || null;
//   console.log('Quatrième image sélectionnée:', this.fourthImage);
// }

// // Méthode appelée lors de la soumission du formulaire
// async onSubmit(): Promise<void> {
//   if (this.mainImage) {
//     const variantData = this.selectedVariants;

//     try {
//       // Upload des images
//       const mainImageUrl = await this.productService.uploadImage(this.mainImage, 'products/main');
//       const secondImageUrl = this.secondImage ? await this.productService.uploadImage(this.secondImage, 'products/second') : null;
//       const thirdImageUrl = this.thirdImage ? await this.productService.uploadImage(this.thirdImage, 'products/third') : null;
//       const fourthImageUrl = this.fourthImage ? await this.productService.uploadImage(this.fourthImage, 'products/fourth') : null;

//       // Ajouter le produit avec les images
//       await this.productService.addProduct(
//         this.productName,
//         this.price,
//         this.quantity,
//         this.description,
//         this.categoryId,
//         this.subcategoryId,
//         mainImageUrl,
//         secondImageUrl,
//         thirdImageUrl,
//         fourthImageUrl,
//         variantData
//       );

//       console.log('Produit ajouté avec succès');
//     } catch (error) {
//       console.error('Erreur lors de l\'ajout du produit :', error);
//     }
//   } else {
//     console.error('L\'image principale est requise.');
//   }
// }
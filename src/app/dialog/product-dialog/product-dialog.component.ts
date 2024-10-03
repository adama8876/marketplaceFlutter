import { CommonModule } from '@angular/common';
import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { ProductService } from '../../Services/prouct.service';
import { CategoryService } from '../../Services/category.service';
import { SubcategoryService } from '../../Services/souscategory.service';
import { VariantTypeService } from '../../Services/variant-type.service';
import { MatCheckboxModule } from '@angular/material/checkbox';

@Component({
  selector: 'app-product-dialog',
  standalone: true,
  imports: [
    CommonModule,           
    ReactiveFormsModule,    // Pour les formulaires réactifs
    MatDialogModule,        // Pour le dialog
    MatFormFieldModule,     // Pour les champs de formulaire Material
    MatInputModule,
    MatSelectModule, 
    MatCheckboxModule,       // Pour les selects (listes déroulantes)
    MatButtonModule
  ],
  templateUrl: './product-dialog.component.html',
  styleUrls: ['./product-dialog.component.css']
})
export class ProductDialogComponent implements OnInit {
  productForm!: FormGroup;
  selectedImages: string[] = [];
  categories: any[] = [];
  subCategories: any[] = [];
  variantTypes: any[] = [];
  selectedFiles: File[] = [];
  variantItems: any[] = [];
  isEditMode: boolean = false;

  constructor(
    private fb: FormBuilder,
    private dialogRef: MatDialogRef<ProductDialogComponent>,
    private productService: ProductService,
    private categoryService: CategoryService,
    private subcategoryService: SubcategoryService,
    private variantTypeService: VariantTypeService,
    @Inject(MAT_DIALOG_DATA) public data: any  // Pour recevoir les données (produit à modifier)
  ) {}

  ngOnInit(): void {
    this.productForm = this.fb.group({
      productName: ['', Validators.required],
      description: ['', Validators.required],
      price: [0, Validators.required],
      quantity: [0, Validators.required],
      category: ['', Validators.required], // La catégorie est maintenant requise
      subCategory: ['', Validators.required],
      variantType: ['', Validators.required],
      variantItem: [[], Validators.required]
    });
  
    // Charger les catégories et les variantes
    this.loadCategories();
    this.loadVariantTypes();
    
    // Si des données de produit sont passées, c'est le mode modification
    if (this.data && this.data.product) {
      this.isEditMode = true;
      this.setProductFormValues(this.data.product);
    }
  }
  

  // Charger les catégories
  loadCategories(): Promise<void> {
    return this.categoryService.getCategoriesWithImages().then((categories) => {
      this.categories = categories;
    });
  }
  

  // Charger les types de variantes
  loadVariantTypes(): Promise<void> {
    return new Promise((resolve) => {
      this.variantTypeService.getVariantTypes().subscribe((variantTypes) => {
        this.variantTypes = variantTypes;
        resolve();
      });
    });
  }
  

  // Charger les sous-catégories en fonction de la catégorie
  onCategoryChange(categorieId: string): Promise<void> {
    return this.subcategoryService.getAllSubcategories().then((subCategories) => {
      this.subCategories = subCategories.filter(subCategory => subCategory.categorieId === categorieId);
    });
  }
  
  

  // Charger les variantes en fonction du type de variante sélectionné
  onVariantTypeChange(variantTypeId: string): void {
    this.variantTypeService.getVariants().subscribe((variants) => {
      this.variantItems = variants.filter(variant => variant.variantTypeId === variantTypeId);
    });
  }

  // Gestion de la sélection des images
  onFileSelected(event: any, index: number): void {
    const file = event.target.files[0];
    if (file) {
      this.selectedFiles[index] = file;
      const reader = new FileReader();
      reader.onload = () => {
        this.selectedImages[index] = reader.result as string;
      };
      reader.readAsDataURL(file);
    }
  }

  // Remplir le formulaire avec les valeurs du produit existant en mode modification
  // Remplir le formulaire avec les valeurs du produit existant en mode modification
setProductFormValues(product: any): void {
  // Charger les catégories pour définir la catégorie sélectionnée
  this.loadCategories().then(() => {
    // Trouver la catégorie correspondante
    const selectedCategory = this.categories.find(category => category.id === product.categoryId);
    this.productForm.patchValue({
      category: selectedCategory ? selectedCategory.id : '', // Définir l'ID de la catégorie
    });

    // Charger les sous-catégories après avoir défini la catégorie
    this.onCategoryChange(product.categoryId).then(() => {
      // Trouver la sous-catégorie correspondante
      const selectedSubCategory = this.subCategories.find(subCategory => subCategory.id === product.subcategoryId);
      this.productForm.patchValue({
        subCategory: selectedSubCategory ? selectedSubCategory.id : '', // Définir l'ID de la sous-catégorie
      });
    });
  });

  // Charger les types de variantes et définir la variante sélectionnée
  this.loadVariantTypes().then(() => {
    this.productForm.patchValue({
      variantType: product.variantType || '',
      variantItem: product.variantData || [],
    });
  });

  // Définir les autres champs du formulaire
  this.productForm.patchValue({
    productName: product.name,
    description: product.description,
    price: product.price,
    quantity: product.quantity,
  });

  // Charger les images existantes pour l'aperçu
  this.selectedImages[0] = product.mainImageUrl || null;
  this.selectedImages[1] = product.secondImageUrl || null;
  this.selectedImages[2] = product.thirdImageUrl || null;
  this.selectedImages[3] = product.fourthImageUrl || null;
}

  
  // Gestion de la soumission du formulaire (Ajout ou Modification)
  // Gestion de la soumission du formulaire (Ajout ou Modification)
async onSubmit(): Promise<void> {
  if (this.productForm.valid) {
    const productData = this.productForm.value;
    const categoryId = productData.category; // Récupère l'ID de la catégorie
    const subCategoryId = productData.subCategory?.id || productData.subCategory;
  
    try {
      // Gestion des uploads d'images : conserver les anciennes URL si aucune nouvelle image n'est sélectionnée
      const uploadedImages = await Promise.all(
        this.selectedFiles.map(async (file, index) => {
          if (file) {
            return await this.productService.uploadImage(file, `products/image-${index + 1}`);
          } else if (this.isEditMode && this.data?.product) {
            // En mode édition, gardez les URL existantes si aucune nouvelle image n'est sélectionnée
            return this.data.product[`mainImageUrl`]; // Ajustez pour gérer les autres images
          }
          return null;
        })
      );

      // Créez l'objet de données pour Firestore
      const updateData: any = {
        productName: productData.productName,
        price: productData.price,
        quantity: productData.quantity,
        description: productData.description,
        categoryId: categoryId, // Incluez l'ID de la catégorie ici
        subcategoryId: subCategoryId,
        mainImageUrl: uploadedImages[0] || (this.isEditMode && this.data?.product?.mainImageUrl) || null, // Conservez l'ancienne URL ou null
        secondImageUrl: uploadedImages[1] || (this.isEditMode && this.data?.product?.secondImageUrl) || null,
        thirdImageUrl: uploadedImages[2] || (this.isEditMode && this.data?.product?.thirdImageUrl) || null,
        fourthImageUrl: uploadedImages[3] || (this.isEditMode && this.data?.product?.fourthImageUrl) || null,
        variantData: productData.variantItem || (this.isEditMode && this.data?.product?.variantData) || []
      };

      // Mise à jour du produit existant
      if (this.isEditMode && this.data?.product?.id) {
        await this.productService.updateProduct(this.data.product.id, updateData);
      } else {
        // Ajout d'un nouveau produit
        await this.productService.addProduct(
          productData.productName,
          productData.price,
          productData.quantity,
          productData.description,
          categoryId, // Passez l'ID de la catégorie ici
          subCategoryId,
          uploadedImages[0], // mainImage
          uploadedImages[1] || null,
          uploadedImages[2] || null,
          uploadedImages[3] || null,
          productData.variantItem
        );
      }

      this.dialogRef.close();
    } catch (error) {
      console.error('Erreur lors de la soumission :', error);
    }
  }
}

  
  
  
  

  // Gestion de la sélection des variantes avec les cases à cocher
  onVariantCheckboxChange(event: any, variantId: string): void {
    let variantItems = this.productForm.value.variantItem || [];

    if (event.checked) {
      variantItems.push(variantId);
    } else {
      variantItems = variantItems.filter((id: string) => id !== variantId);
    }

    this.productForm.patchValue({
      variantItem: variantItems
    });
  }

  onClose(): void {
    this.dialogRef.close();
  }
}

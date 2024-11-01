class FormValidators {
  static String? validatePrenom(String? value) {
    if (value!.isEmpty) {
      return 'Veuillez entrer votre prénom';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Le prénom ne doit contenir que des lettres';
    }
    return null;
  }

  

  static String? validateNom(String? value) {
    if (value!.isEmpty) {
      return 'Veuillez entrer votre nom';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Le nom ne doit contenir que des lettres';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Veuillez entrer votre email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  static String? validateTelephone(String? value) {
    if (value!.isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Le numéro de téléphone doit contenir uniquement des chiffres';
    }
    return null;
  }

  static String? validateMotDePasse(String? value) {
    if (value!.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value!.isEmpty) {
      return 'Veuillez entrer une description pour votre boutique';
    }
    if (value.length < 50) {
      return 'Veuillez entrer une courte description de votre boutique';
    }
    return null;
  }



   static String? validateNomBoutique(String? value) {
    if (value!.isEmpty) {
      return 'Veuillez entrer votre le nom de vore qoutique';
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Le nom ne doit contenir que des lettres';
    }
    return null;
  }
}

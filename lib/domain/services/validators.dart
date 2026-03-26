class Validators {
  const Validators();

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe seu e-mail';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'E-mail invalido';
    return null;
  }

  String? validarSenha(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha';
    if (value.length < 8) return 'A senha deve ter no minimo 8 caracteres';
    if (!RegExp('[a-zA-Z]').hasMatch(value)) {
      return 'A senha deve conter ao menos 1 letra';
    }
    if (!RegExp('[0-9]').hasMatch(value)) {
      return 'A senha deve conter ao menos 1 numero';
    }
    return null;
  }

  String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe seu nome';
    if (value.trim().length < 2) return 'Nome muito curto';
    return null;
  }

  String? validarIdade(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua idade';
    final idade = int.tryParse(value);
    if (idade == null || idade < 10 || idade > 120) {
      return 'Idade deve ser entre 10 e 120 anos';
    }
    return null;
  }

  String? validarPeso(String? value) {
    if (value == null || value.isEmpty) return 'Informe seu peso';
    final peso = double.tryParse(value.replaceAll(',', '.'));
    if (peso == null || peso < 30 || peso > 300) {
      return 'Peso deve ser entre 30 e 300 kg';
    }
    return null;
  }

  String? validarAltura(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua altura';
    final altura = double.tryParse(value.replaceAll(',', '.'));
    if (altura == null || altura < 100 || altura > 250) {
      return 'Altura deve ser entre 100 e 250 cm';
    }
    return null;
  }

  String? validarMetaCalorica(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua meta calorica';
    final meta = int.tryParse(value);
    if (meta == null || meta < 800 || meta > 6000) {
      return 'Meta deve ser entre 800 e 6000 kcal';
    }
    return null;
  }
}

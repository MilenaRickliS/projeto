# 🌟 Projeto Flutter - Aplicativo Mobile Loja de Cosméticos

Este é um aplicativo desenvolvido em **Flutter**, com o objetivo de expor, filtrar e vender produtos cosméticos de forma moderna e eficiente.

## 🚀 Funcionalidades Principais

- Interface responsiva e moderna
- Pesquisa de produtos
- Sistema de **login e cadastro** com Firebase Authentication
- Integração com **Firestore** para gerenciamento de usuários e pedidos
- **Favoritos**: adiciona e remove produtos dos favoritos
- **Carrinho de compras** com visualização de itens e cálculo de total
- **Finalização de compra** com endereço, forma de pagamento, confirmação, visualização de pedidos e seus detalhes
- **Filtro por categorias**: filtra os produtos da api por categoria
- Integração com **API externa** para visualização produtos
- **Tela Detalhes de produtos** visualização individual de cada produto
- Preenchimento automático de endereço via busca por CEP

## 📱 Tecnologias Utilizadas

- [Flutter](https://flutter.dev/) (Dart)
- [Provider](https://pub.dev/packages/provider) – gerenciamento de estado
- [Firebase Auth & Firestore](https://firebase.google.com/) – backend
- [HTTP](https://pub.dev/packages/http) – comunicação com API externa
- [uuid](https://pub.dev/packages/uuid) – geração de IDs únicos
- [logger](https://pub.dev/packages/logger) – logs de depuração
- [flutter_masked_text2](https://pub.dev/packages/flutter_masked_text2) – máscaras de texto
- [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) – formatação de inputs
- [search_cep](https://pub.dev/packages/search_cep) – busca automática de endereço via CEP
- [carousel_slider](https://pub.dev/packages/carousel_slider) – banners e carrosséis
- [shimmer](https://pub.dev/packages/shimmer) – efeito de carregamento
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) – ícones personalizados

## 🛠️ Como Instalar e Rodar o Projeto

### ✅ Pré-requisitos

Antes de iniciar, certifique-se de ter instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (geralmente incluso no Flutter)
- Android Studio ou Visual Studio Code
- Emulador Android ou dispositivo físico configurado
- Conta e projeto no [Firebase](https://firebase.google.com/)

### 📦 Passos para Executar

1. **Clone o repositório:**

```bash
git clone https://github.com/MilenaRickliS/projeto.git
cd projeto
```

2. **Instale as dependências:**

```bash
flutter pub get
```

3. **Configure o Firebase:**

- Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
- Ative os seguintes serviços:
  - Authentication (Email/Senha)
  - Firestore Database
- Faça o download do arquivo `google-services.json` e coloque em `android/app/`
- (iOS) Faça o download do `GoogleService-Info.plist` e adicione em `ios/Runner/`

4. **Executar aplicativo:**

```bash
flutter run
```

## 🗂️ Estrutura Esperada no Firestore

### 📁 Coleção: `usuarios`

| Campo           | Tipo      |
|----------------|-----------|
| cep            | String    |
| cidade         | String    |
| cpf            | String    |
| criadoEm       | Timestamp |
| dataNascimento | String    |
| email          | String    |
| estado         | String    |
| genero         | String    |
| nome           | String    |
| numeroCasa     | String    |
| rua            | String    |
| telefone       | String    |
| uid            | String    |

### 📁 Coleção: `pedidos`

| Campo          | Tipo                           |
|----------------|--------------------------------|
| cidade         | String                         |
| estado         | String                         |
| formaPagamento | String                         |
| itens          | Lista de objetos `{nome, preco, quantidade}` |
| numeroCasa     | String                         |
| rua            | String                         |
| total          | double                         |
| uidCliente     | String                         |
| uidPedido      | String                         |

## 👩‍💻 Desenvolvedora

**Milena Rickli Silvério Kriger**

[GitHub](https://github.com/MilenaRickliS)

enum UploadType {
  shopsLogo,
  shopsBack,
  products,
  reviews,
  users,
  chats,
}

enum ExtrasType { color, text, image }

enum LayoutType { twoH, three, twoV, one, newUi }

enum DeliveryTypeEnum { delivery, pickup, digital }

enum OrderStatus { open, accepted, ready, onWay, delivered, canceled }

enum AuthType {
  login,
  signUpSendCode,
  confirm,
  signUpFull,
  forgetPassword,
  updatePassword,
}

enum SignUpType{
  phone,
  email,
  both
}

enum FilterType {
  news,
  popular,
  mostSold,
  // bestRate,
  priceMin,
  priceMax,
}

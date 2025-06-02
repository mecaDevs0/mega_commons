enum PersonType {
  legalPerson('Pessoa Jurídica'),
  physicalPerson('Pessoa Física');

  const PersonType(this.description);
  final String description;
}

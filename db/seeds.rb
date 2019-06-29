# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
teste = Company.create(name: "Companye Teste", description: "descrição teste")
teste.projects.create(name: "Projeto Teste", description: "descrição projeto")

lu = User.create(username: "lucas", email: "lucas@apple.com", password: "12345", password_confirmation: "12345")
lu.register(perk: "Employee", company_id: 1, first_name: "Lucas", second_name: "Seila", birthdate: "2005-10-28")

to = User.create(username: "ttomaaz", email: "ttomaaz@impiricus.com", password: "12345", password_confirmation: "12345")
to.register(perk: "Operational", first_name: "Tomaz", second_name: "Henrique", birthdate: "1985-08-05")

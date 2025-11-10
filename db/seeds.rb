# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create Admin User
admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "Admin User"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :admin
  user.company_id = nil
end

puts "Admin user created:"
puts "  Email: #{admin.email}"
puts "  Password: password123"
puts "  Role: #{admin.role}"

# Create sample companies
company1 = Company.find_or_create_by!(name: "ACME Transport Ltd")
company2 = Company.find_or_create_by!(name: "Swift Logistics Inc")

puts "\nSample companies created:"
puts "  - #{company1.name}"
puts "  - #{company2.name}"

# Create manager for company1
manager1 = User.find_or_create_by!(email: "manager@acme.com") do |user|
  user.name = "John Manager"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :manager
  user.company = company1
end

# Create driver for company1
driver1 = User.find_or_create_by!(email: "driver@acme.com") do |user|
  user.name = "Jane Driver"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :driver
  user.company = company1
end

# Create manager for company2
manager2 = User.find_or_create_by!(email: "manager@swift.com") do |user|
  user.name = "Bob Manager"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :manager
  user.company = company2
end

puts "\nSample users created:"
puts "  ACME Transport Ltd:"
puts "    - Manager: #{manager1.email} (password123)"
puts "    - Driver: #{driver1.email} (password123)"
puts "  Swift Logistics Inc:"
puts "    - Manager: #{manager2.email} (password123)"

# Create sample vehicles for company1
vehicle1 = Vehicle.find_or_create_by!(license_plate: "AB12CDE", company: company1) do |v|
  v.make = "Ford"
  v.model = "Transit"
  v.year = 2022
  v.color = "White"
  v.vin = "1HGBH41JXMN109186"
end

vehicle2 = Vehicle.find_or_create_by!(license_plate: "XY34ZAB", company: company1) do |v|
  v.make = "Mercedes"
  v.model = "Sprinter"
  v.year = 2023
  v.color = "Silver"
  v.vin = "2HGBH41JXMN109187"
end

# Create sample vehicles for company2
vehicle3 = Vehicle.find_or_create_by!(license_plate: "CD56EFG", company: company2) do |v|
  v.make = "Volkswagen"
  v.model = "Crafter"
  v.year = 2021
  v.color = "Blue"
  v.vin = "3HGBH41JXMN109188"
end

puts "\nSample vehicles created:"
puts "  ACME Transport Ltd: #{company1.vehicles.count} vehicles"
puts "  Swift Logistics Inc: #{company2.vehicles.count} vehicles"

# Create sample assignments for company1
assignment1 = Assignment.find_or_create_by!(driver: driver1, vehicle: vehicle1, date: Date.today) do |a|
  a.company = company1
end

assignment2 = Assignment.find_or_create_by!(driver: driver1, vehicle: vehicle2, date: Date.tomorrow) do |a|
  a.company = company1
end

assignment3 = Assignment.find_or_create_by!(driver: driver1, vehicle: vehicle1, date: Date.today + 2) do |a|
  a.company = company1
end

puts "\nSample assignments created:"
puts "  ACME Transport Ltd: #{company1.assignments.count} assignments"
puts "\nSeeding completed successfully!"

# Create a database.yml for the right database
echo "Setting up database.yml for $DB"
cp "test/files/database.$DB.yml" "test/dummy/config/database.yml"

# Set up database
echo "Creating databases for $DB and loading schema"
cp -r "test/fixtures" "test/dummy/test/"
cd "test/dummy"
if [ "$DB" = "mysql" ]; then
  mysql -e 'create database forgeos_core_test;'
else
  bundle exec rake db:create
fi
echo "Loading Fixtures"
bundle exec rake db:test:prepare db:fixtures:load

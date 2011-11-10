# Create a database.yml for the right database
echo "Setting up database.yml for $DB"
cp "test/files/database.yml.$DB" "test/dummy/config/database.yml"

# Set up database
echo "Creating databases for $DB and loading schema"
cp -r "test/fixtures" "test/dummy/test/"
cd "test/dummy"
bundle exec rake db:create
echo "Loading Fixtures"
bundle exec rake db:test:prepare db:fixtures:load
echo "Building Sphinx Index"
bundle exec rake ts:rebuild

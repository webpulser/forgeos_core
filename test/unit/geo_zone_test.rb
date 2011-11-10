require 'test_helper'

class GeoZoneTest < ActiveSupport::TestCase
  test "should give a hash for jstree" do
    geo_zone = GeoZone.create(:name => 'toto')
    assert_kind_of Hash, geo_zone.to_jstree
    assert_equal({
      :attributes => {
        :id => "geo_zone_#{geo_zone.id}",
        :type => 'folder'
      },
      :data => {
        :title => 'toto',
        :attributes => {
          :class => 'big-icons',
          :style => 'category_picture',
        }
      }
    }, geo_zone.to_jstree)
  end

  test "should give hash for jstree with count" do
    class ::TestGeoZone < GeoZone
      def users
        User.all
      end
    end
    geo_zone = TestGeoZone.create(:name => 'toto')
    assert_equal({
      :attributes => {
        :id => "test_geo_zone_#{geo_zone.id}",
        :type => 'folder'
      },
      :data => {
        :title => 'toto<span>3</span>',
        :attributes => {
          :class => 'big-icons',
          :style => 'category_picture',
        }
      }
    }, geo_zone.to_jstree(:users))
  end

  test "should give hash for jstree with children" do
    geo_zone = GeoZone.create(:name => 'toto')
    child_geo_zone = GeoZone.create(:name => 'tata', :parent => geo_zone)
    assert_equal({
      :attributes => {
        :id => "geo_zone_#{geo_zone.id}",
        :type => 'folder'
      },
      :data => {
        :title => 'toto',
        :attributes => {
          :class => 'big-icons',
          :style => 'category_picture',
        }
      },
      :children => [{
        :attributes => {
          :id => "geo_zone_#{child_geo_zone.id}",
          :type => 'folder'
        },
        :data => {
          :title => 'tata',
          :attributes => {
            :class => 'big-icons',
            :style => 'category_picture',
          }
        }
      }]
    }, geo_zone.to_jstree)
  end

end

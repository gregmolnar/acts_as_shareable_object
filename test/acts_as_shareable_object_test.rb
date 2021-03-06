require 'test_helper'

class ActsAsShareableObjectTest < ActiveSupport::TestCase
  fixtures :cars

  test "truth" do
    assert_kind_of Module, ActsAsShareableObject
  end

  test "twitter summary card type" do
    car = cars(:pagani)

    car.stubs(:twitter_card).returns("summary")

    assert_equal car.social_meta_properties[:twitter][:card], "summary"
  end

  test "twitter summary card image" do
    car = cars(:pagani)

    car.stubs(:twitter_image).returns(car.image)

    assert_equal car.social_meta_properties[:twitter][:image], car.image
  end

  test "twitter card site" do
    car = cars(:pagani)

    car.stubs(:twitter_site).returns(car.company_twitter_handle)

    assert_equal car.social_meta_properties[:twitter][:site], car.company_twitter_handle
  end

  test "twitter photo card image src" do
    car = cars(:pagani)

    car.stubs(:twitter_image_src).returns(car.image)

    assert_equal car.social_meta_properties[:twitter][:image][:src], car.image

  end

  test "twitter photo card image details" do
    car = cars(:pagani)

    car.stubs(:twitter_image_src).returns(car.image)
    car.stubs(:twitter_image_width).returns("812")
    car.stubs(:twitter_image_height).returns("475")

    assert_equal car.social_meta_properties[:twitter][:image][:src], car.image
    assert_equal car.social_meta_properties[:twitter][:image][:width], car.twitter_image_width
    assert_equal car.social_meta_properties[:twitter][:image][:height], car.twitter_image_height
  end

  test "single custom tag" do
    car = cars(:pagani)

    class << car
      acts_as_shareable_object :og_test
    end

    car.stubs(:og_test).returns("test tag, YO")

    assert_equal car.social_meta_properties[:og_test], car.og_test
  end

  test "single nested custom tag" do
    car = cars(:pagani)

    class << car
      acts_as_shareable_object og: :nested
    end

    car.stubs(:og_nested).returns("this is nested")

    assert_equal car.social_meta_properties[:og][:nested], car.og_nested
  end

  test "single nested array custom tag" do
    car = cars(:pagani)

    class << car
      acts_as_shareable_object og: [:nested]
    end

    car.stubs(:og_nested).returns("this is nested")

    assert_equal car.social_meta_properties[:og][:nested], car.og_nested
  end

  test "multiple custom shareable tags" do
    car = cars(:pagani)

    class << car
      acts_as_shareable_object og: [:custom_property, nested: [:egg]]
    end

    car.stubs(:og_custom_property).returns("og custom property")
    car.stubs(:og_nested_egg).returns("nested egg")

    assert_equal car.social_meta_properties[:og][:custom_property], car.og_custom_property
    assert_equal car.social_meta_properties[:og][:nested][:egg], car.og_nested_egg
  end

end

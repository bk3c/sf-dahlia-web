# RESTful JSON API to retrieve data for My Account
class Api::V1::AccountController < ApiController
  before_action :authenticate_user!

  def my_applications
    applications = map_listings_to_applications(current_user_applications)
    render json: { applications: applications }
  end

  private

  def current_user_applications
    ShortFormService.get_for_user(current_user.salesforce_contact_id)
  end

  def map_listings_to_applications(applications)
    listing_ids = applications.collect { |a| a['listingID'] }.uniq
    listings = ListingService.listings(listing_ids.join(','))
    applications.each do |app|
      app['listing'] = listings.find { |l| l['listingID'] == app['listingID'] }
    end
  end
end

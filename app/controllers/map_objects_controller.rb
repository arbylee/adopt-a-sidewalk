class MapObjectsController < ApplicationController
  respond_to :json

  def show
    @sidewalks = MapObject.find_closest(params[:lat], params[:lng], params[:limit] || 40)
    unless @sidewalks.blank?
      respond_with(@sidewalks) do |format|
        format.kml { render }
      end
    else
      render(:json => {"errors" => {"address" => [t("errors.not_found", :thing => t("defaults.thing"))]}}, :status => 404)
    end
  end

  def update
    @map_object = MapObject.find(params[:id])
    if @map_object.update_attributes(params[:thing])
      respond_with @map_object
    else
      render(:json => {"errors" => @map_object.errors}, :status => 500)
    end
  end
end
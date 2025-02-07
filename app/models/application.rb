class Application < ApplicationRecord
  require "net/http"
  broadcasts_refreshes

  def elegibility
    if amount > 10000
      "We do not fund applications over £10,000"
    elsif amount < 1000
      "We do not fund applications under £1,000"
    else
      true
    end
  end

  def elegible?
    elegibility == true
  end

  def keen_to_hear_more?
    good_points.count > bad_points.count
  end

  def good_points
    points = []
    points << "You are asking for an expected amount of money per person" if per_person < 60 && per_person > 10
    points << "You are working in an area with a high level of deprivation" if imd_decile < 5
    points << "You are working with demographics that we are particularly interested in" if demographic_target_score > 10
    points << "We aren't currently funding much for #{primary_demographic} in #{location_name}" unless already_funding?(primary_demographic)
    points << "We aren't currently funding much for #{sport} in #{location_name}" unless already_funding?(sport)
    points
  end

  def bad_points
    points = []
    points << "It seems like you are asking for a lot of money per person" if per_person > 100
    points << "You're asking for less per person than we would expect" if per_person < 10
    points << "You are working in an area with a low level of deprivation" if imd_decile > 5
    points << "It doesn't look like you're including groups that we are particularly interested in funding" if demographic_target_score < 10
    points << "We already fund lots of organisations for #{primary_demographic} in #{location_name}" if already_funding?(primary_demographic)
    points << "We already fund lots of organisations for #{sport} in #{sport}" if already_funding?(sport)
    points
  end

  def per_person
    amount.to_i / people_count.to_i
  rescue ZeroDivisionError
    0
  end

  def self.average_per_person
    30
  end

  def per_person_offset
    (per_person - self.class.average_per_person).abs
  end

  def above_average_per_person?
    per_person > self.class.average_per_person
  end

  def demographic_target_score
    low_income.to_i + children.to_i + lgbtq.to_i + older.to_i
  end

  def imd
    @imd_cache ||= begin
      response = Net::HTTP.get(URI("https://imd.abscond.org/imd?lat=#{self.lat}&lon=#{self.long}"))
      if response.present? && response["error"].nil?
        JSON.parse(response)
      else
        nil
      end
    end
  end

  def location_name
    imd["lsoa01nm"] if imd.present?
  end

  def imd_decile
    imd["imd_decile"].to_i if imd.present?
  end

  def applications_in_location
    Random.new(location_name.hash).rand(0..10)
  end

  def already_funding?(name)
    Random.new(location_name.hash + name.hash).rand(0..1) == 1
  end

  def primary_demographic
    demographics = {
      "People on Low Income" => low_income.to_i,
      "Children" => children.to_i,
      "LGBTQ people" => lgbtq.to_i,
      "Older people" => older.to_i
    }
    demographics.max_by { |_, value| value }[0]
  end
end

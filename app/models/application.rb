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

  def score
    score = 0
    score += 1 if per_person < 100
    score -= 1 if per_person > 1000
    score
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
    response = Net::HTTP.get(URI("https://imd.abscond.org/imd?lat=#{self.lat}&lon=#{self.long}"))
    if response.present? && response["error"].nil?
      JSON.parse(response)
    else
      nil
    end
  end
end

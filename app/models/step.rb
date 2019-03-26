class Step < ActiveRecord::Base
  belongs_to :recipe

  def self.create_from_data(data, recipe_id)
    step = self.create({
        recipe_id: recipe_id,
        number: data["number"],
        step: data["step"]
      })
      if !data["length"].nil?
        step.update(length: "#{data["length"]["number"]} #{data["length"]["unit"]}.")
      end
  end

end

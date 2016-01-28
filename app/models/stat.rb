class Stat < ActiveRecord::Base
  belongs_to :video
  belongs_to :report
end

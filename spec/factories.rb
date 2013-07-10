FactoryGirl.define do
  factory :user do
    email    "j.l.spangler@nasa.gov"
    password "s42921"
    password_confirmation "s42921"
  end
  factory :sensor do
    name "some sensor"
    category "LVD transducer"
    mcn "A999999"
    model "632-11E"
    serial "2167"
  end
end
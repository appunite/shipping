alias Shipping.Shipper.Commands.CreateLoad
alias Shipping.Shipper
alias Shipping.Shipper.LoadServer
alias Shipping.Driver.Events.LoadRequestSent


command = %CreateLoad{
  uuid: "uuid",
  shipper_id: "shipper_id",
  car_type: :small,
  number_of_trips: 5,
  start_date_millis: 1000,
  lat: 10.0,
  lng: 10.0
}

command2 = %CreateLoad{
  uuid: "uuid2",
  shipper_id: "shipper_id",
  car_type: :small,
  number_of_trips: 5,
  start_date_millis: 1000,
  lat: 10.0,
  lng: 10.0
}

load_request_event = %LoadRequestSent{
  uuid: "request_uuid",
  load_id: "load_uuid",
  driver_id: "driver_uuid",
  timestamp: 10
}


:observer.start()

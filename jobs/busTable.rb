headers = [
    {cols: [
    {value: "Buss"},
    {value: "Mot"},
    {value: "Departs"},
    {value: "Disturbances"}]
}
]

rows = [{"cols"=>[{"value"=>"179"}, {"value"=>"Sollentuna Station"}, {"value"=>"08:32"}, {"value"=>"Inga"}]},
        {"cols"=>[{"value"=>"179"}, {"value"=>"Sollentuna Station"}, {"value"=>"08:32"}, {"value"=>"Delayed due to Queues"}]},
        {"cols"=>[{"value"=>"Name 3"}, {"value"=>"Value 3"}]},
        {"cols"=>[{"value"=>"Name 4"}, {"value"=>"Value 4"}]}]
SCHEDULER.every '1h' do
send_event("sltable1", { hrows: headers, rows: rows } )
  end
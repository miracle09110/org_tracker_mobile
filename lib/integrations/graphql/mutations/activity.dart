const String addActivityQuery =  r'''
                    mutation AddActivity(
                      $event_name: String!
                      $venue: String!
                      $start_date: String!
                      $end_date: String!
                      $start_time: String!
                      $end_time: String!
                      $image: String!
                      $description: String!
                    ){
                      addActivity (
                        event_name : $event_name,
                        venue : $venue,
                        start_date : $start_date,
                        end_date : $end_date,
                        start_time : $start_time,
                        end_time : $end_time,
                        image_base_64 : $image,
                        description :  $description
                       ){
                        event_name,
    	                  venue
                      }
                    }
                  ''';
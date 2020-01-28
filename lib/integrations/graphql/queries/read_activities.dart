const String activityQuery = r"""
                    query {
                      activities{
                        event_name
                        start_date
                        end_date
                        venue
                        image_base_64
                        description
                        start_time
                        end_time
                      }
                    }
                  """;
const String addMemberQuery =  """
                    mutation {
                      addMember (
                        name : {
                          first_name : \$first_name,
                          last_name : \$last_name,
                          middle_initial : \$middle_initial,
                          nickname : \$nickname
                        },
                        contact_info: {
                          email : \$email,
                          phone_number : \$phone_number
                        },
                        profession: {
                          job_title : \$job_title,
                          employer : \$employer,
                          field : \$field
                        },
                        date_of_birth: \$date_of_birth,
                        batch : \$batch,
                        status : \$status,
                        cluster_id : \$cluster_id
                       ){
                        name {
    	                    first_name
    	                    last_name
    	                    middle_initial
    	                    nickname
    	                   }
                      }
                    }
                  """;
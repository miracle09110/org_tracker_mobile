const String addMemberQuery =  r'''
                    mutation AddMember (
                    $first_name: String!
                    $last_name: String!
                    $middle_initial: String!
                    $nickname: String!
                    $email: String!
                    $phone_number: String!
                    $job_title: String!
                    $employer: String!
                    $field: String!
                    $batch: String!
                    $status: String!
                    $cluster_id: ID!
                    $date_of_birth: String!
                    ){
                      addMember (
                        name : {
                          first_name : $first_name,
                          last_name : $last_name,
                          middle_initial : $middle_initial,
                          nickname : $nickname
                        },
                        contact_info: {
                          email : $email,
                          phone_number : $phone_number
                        },
                        profession: {
                          job_title : $job_title,
                          employer : $employer,
                          field : $field
                        },
                        date_of_birth: $date_of_birth,
                        batch : $batch,
                        status : $status,
                        cluster_id : $cluster_id
                       ){
                        name {
    	                    first_name
    	                    last_name
    	                    middle_initial
    	                    nickname
    	                   }
                      }
                    }
                  ''';
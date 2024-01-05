module Api.Tracker exposing (..)

import Api.Client exposing (get, getErrorMessage, getList, post, put)
import Common.Tracker.Visits exposing (Visits, visitsDecoder)
import Http


url : String
url =
    "https://tracker.realmoneycompany.com/visits"


getVisits : (Result Http.Error Visits -> msg) -> Cmd msg
getVisits msg =
    get msg visitsDecoder url


getGetVisitsErrorMessage : Http.Error -> String
getGetVisitsErrorMessage error =
    getErrorMessage error "Get visits failed."

module Pages.Tracker.TrackerClient exposing (..)

import Http
import Modules.Client exposing (get, getErrorMessage, getList, post, put)
import Pages.Tracker.Visits exposing (Visits, visitsDecoder)


url : String
url =
    "https://tracker.realmoneycompany.com/visits"


getVisits : (Result Http.Error Visits -> msg) -> Cmd msg
getVisits msg =
    get msg visitsDecoder url


getGetVisitsErrorMessage : Http.Error -> String
getGetVisitsErrorMessage error =
    getErrorMessage error "Get visits failed."

module Common.Date exposing (..)

import Iso8601
import Json.Decode
import Json.Encode
import Time


type alias Date =
    { time : Time.Posix
    , zone : Time.Zone
    }


dateFromMs : Int -> Date
dateFromMs posixInMs =
    Date (Time.millisToPosix posixInMs) Time.utc


decodeDate : Json.Decode.Decoder Date
decodeDate =
    Json.Decode.int
        |> Json.Decode.andThen (\ms -> Json.Decode.succeed (Time.millisToPosix ms))
        |> Json.Decode.andThen (\posix -> Json.Decode.succeed (Date posix Time.utc))


encodeDate : Date -> Json.Encode.Value
encodeDate date =
    Json.Encode.int (Time.posixToMillis date.time)


formatMonth : Time.Month -> String
formatMonth month =
    case month of
        Time.Jan ->
            "01"

        Time.Feb ->
            "02"

        Time.Mar ->
            "03"

        Time.Apr ->
            "04"

        Time.May ->
            "05"

        Time.Jun ->
            "06"

        Time.Jul ->
            "07"

        Time.Aug ->
            "08"

        Time.Sep ->
            "09"

        Time.Oct ->
            "10"

        Time.Nov ->
            "11"

        Time.Dec ->
            "12"


zfill : String -> String
zfill str =
    case String.toList str of
        [] ->
            "00"

        [ c ] ->
            "0" ++ String.fromChar c

        _ ->
            str


parseIso8601ToDateTime : String -> Date
parseIso8601ToDateTime value =
    case Iso8601.toTime value of
        Ok posix ->
            Date posix Time.utc

        Err _ ->
            Date (Time.millisToPosix 0) Time.utc


parseDateTimeToIso8601 : Date -> String
parseDateTimeToIso8601 value =
    String.replace "Z" "" (Iso8601.fromTime value.time)


formatDate : Date -> String
formatDate date =
    let
        year =
            String.fromInt (Time.toYear date.zone date.time)

        month =
            formatMonth (Time.toMonth date.zone date.time)

        day =
            String.fromInt (Time.toDay date.zone date.time)

        hour =
            String.fromInt (Time.toHour date.zone date.time)

        minute =
            String.fromInt (Time.toMinute date.zone date.time)

        second =
            String.fromInt (Time.toSecond date.zone date.time)
    in
    zfill hour ++ ":" ++ zfill minute ++ ":" ++ zfill second ++ " " ++ zfill day ++ "/" ++ month ++ "-" ++ year

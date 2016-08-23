module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Json.Decode as JsD exposing ((:=))
import Json.Encode as JsE
import Http
import Task exposing (Task)
import Task.Extra exposing (..)
import Maybe exposing (Maybe)


-- MODEL

type alias Traduccion = {
  texto : String,
  italiano : String,
  ingles : String,
  id: Int
}

type alias Model = {
  traducciones : List Traduccion
}

modeloInicial : Model
modeloInicial = {
  traducciones = []  
  }
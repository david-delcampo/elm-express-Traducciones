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
  
init : (Model, Cmd Msg)
init = (modeloInicial, findAll)
  
  
-- MSG (after: EFFECTS)


traduccionesDecoder : JsD.Decoder (List Traduccion)
traduccionesDecoder =
  JsD.list traduccionDecoder


traduccionDecoder : JsD.Decoder Traduccion
traduccionDecoder =
  JsD.object4 Traduccion
    ("texto" := JsD.string)
    ("italiano" := JsD.string)
    ("ingles" := JsD.string)
    ("id" := JsD.int)

traduccionesEncoder : List Traduccion -> String
traduccionesEncoder traducciones =
  let
    listaDeObjectsJsE  = List.map traduccionEncoder traducciones
    objectJsE = JsE.list (listaDeObjectsJsE)
  in
    JsE.encode 0 objectJsE

traduccionEncoder : Traduccion -> JsE.Value
traduccionEncoder traduccion =
    JsE.object
          [ ("texto", JsE.string traduccion.texto),
            ("italiano", JsE.string traduccion.italiano),
            ("ingles", JsE.string traduccion.ingles),
            ("id", JsE.int traduccion.id) ]

baseUrl : String
baseUrl =
    "http://127.0.0.1:3000/db/"

findAll : Cmd Msg
findAll =
  Http.get traduccionesDecoder baseUrl
    |> Task.toMaybe
    |> Task.Extra.performFailproof SetTraducciones

actualizarTraducciones : List Traduccion -> Cmd Msg
actualizarTraducciones traducciones =
  let
      body =
        Http.string (traduccionesEncoder traducciones)
  in
      Http.send Http.defaultSettings
        {
          verb = "POST",
          headers =
            [ ( "Content-Type", "application/json" ),
              ( "Accept", "application/json" )
            ],
          url = baseUrl,
          body = body
        }
        |> Http.fromJson traduccionesDecoder
        |> Task.toMaybe
        |> Task.Extra.performFailproof SetTraducciones  
        
        
-- UPDATE

type Msg
  = SetTraducciones (Maybe (List Traduccion))
  | UpdateTraduccionIngles Traduccion String
  | Aceptar Traduccion
  | Cancelar

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetTraducciones response ->
      case response of
        Just traducciones ->
          ({ model | traducciones = traducciones }, Cmd.none)
        Nothing ->
            (model, Cmd.none)
    
    UpdateTraduccionIngles traduccion ingles ->
      let         
         newTraduccion = ({ traduccion | ingles = ingles })
      in
        ({model | traducciones = List.map (cambiarTraduccion newTraduccion) model.traducciones}, Cmd.none)    
    
    Aceptar traduccion ->
      (model, actualizarTraducciones model.traducciones)
        
    Cancelar ->
      (model, Cmd.none)

cambiarTraduccion : Traduccion -> Traduccion -> Traduccion
cambiarTraduccion new old =
  case new.id == old.id of
    True -> new
    False -> old          
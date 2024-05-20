open Cohttp_lwt_unix

let ( let* ) = Lwt.bind

let callback _conn req _body =
  let uri = req |> Request.uri |> Uri.path in
  match uri with
  | "/sleep" ->
      let rec sleep () =
        let* () = Lwt_unix.sleep 1.0 in
        Format.printf "I slept @.";
        sleep ()
      in
      sleep ()
  | _ -> Server.respond_string ~status:`Not_found ~body:"Not found" ()

let start_server () =
  let port = 8080 in
  let server =
    Server.create
      ~mode:(`TCP (`Port port))
      (Server.make
         ~conn_closed:(fun _conn -> Format.printf "Server closed @.")
         ~callback ())
  in
  Printf.printf "Server running on port %d\n%!" port;
  server

let () = Lwt_main.run (start_server ())

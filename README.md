# LiveTinkering
* [Initial steps](#initial-steps)
  * [Javascript setup](#javascript-setup)
  * [Elixir setup](#elixir-setup)
* [Code!](#code)
  * [`ClockLive`](#clocklive)
    * [`mount/2`](#mount2)
    * [`handle_info/2`](#handleinfo2)
    * [`render/1`](#render1)
  * [`live_render`](#liverender)

A little toy repo to show off a very unnecessarily fast-rendering clock, done with [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view). There's also a keyboard demo in here, just haven't had a chance to write it up yet, but it _does_ have a super cute bear 🐻.

_Please note that LiveView hasn't been officially released yet!_

Overall the setup is quite straightforward, I'm just real verbose. The blurbs below don't match the repo exactly, as a heads up, but only in that I added an extra function, a variable, etc.

The current LiveView docs are inline yet, I think, but you can see them [here](https://github.com/phoenixframework/phoenix_live_view/blob/master/lib/phoenix_live_view.ex).

None of this is necessary if you're cloning down the repo (I think), but this is what I did to actually get everything set up from a basic Phoenix project.

Nothing interesting beyond what the LiveView docs already say, but I like having things in one place.

## Initial steps

First, create a new Phoenix project.

For this one, I ran `mix phx.new live_tinkering --no-ecto`. (The `--no-ecto` option is to skip adding Ecto as a dependency, since I'm not using a database here.) Go ahead and follow any prompts that come up; I think there's one about installing dependencies.

We need to add `phoenix_live_view` as a dependency in our `assets` -- remember to run `npm install` after this _from your `assets` folder_. Update your `package.json` file so that `"dependencies"` looks like this.

(Please note the trailing comma on the last line if you are copying and pasting; JSON is real touchy about commas.)

```json
"dependencies": {
    "phoenix": "file:../deps/phoenix",
    "phoenix_html": "file:../deps/phoenix_html",
    "phoenix_live_view": "file:../deps/phoenix_live_view"
},
```

### Javascript setup

Since we're checking out assets anyways, let's update our `assets/js/app.js` file while we're here:

```javascript
// assets/js/app.js

// ... rest of your js file here ...

import LiveSocket from 'phoenix_live_view';

let liveSocket = new LiveSocket("/live");
liveSocket.connect();
```

There! That's it. That's all the JS we're writing today.

### Elixir setup

Onwards!

You can get a secret key by running `mix phx.gen.secret 32` in a terminal.

The new bit added to your `config/config.exs` is a signing salt for live view -- you need to add an option of `live_view: [signing_salt: <SALT_GOES_HERE_IN_QUOTES>`. e.g., if your salt was `"sodium_chloride"` you'd _add_ this to your config portion under `config <your_app_name>, <YourAppNameWebModule.Endpoint>` as `live_view: [signing_salt: "sodium_chloride"]`. (Don't forget to add a comma to the line before -- here that was after `... Phoenix.PubSub.PG2]`)

```elixir
# config/config.exs

config :live_tinkering, LiveTinkeringWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GDMQPLUkLSPoqUT8vaimRrwv6oFFFWn3ooE/g9fd6aU95V3yeTBabNCj4zc70MkZ",
  render_errors: [view: LiveTinkeringWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveTinkering.PubSub, adapter: Phoenix.PubSub.PG2],
  # this next line is the new bit
  live_view: [signing_salt: "gqKkGatgzyF+N1umutKWxm5fuaAKDFDR"]

# ... rest of your config file here ...

# these next lines are the new bit
config :phoenix,
    template_engines: [leex: Phoenix.LiveView.Engine]
```

Update your dev config, if you would like live-reloading for your `leex` files. (Full disclosure, I haven't gotten `leex` files to work yet, so, uh, keep that in mind here.)

```elixir
# config/dev.exs

config :live_tinkering, LiveTinkeringWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/live_tinkering_web/views/.*(ex)$},
      # this next line is the new bit
      ~r{lib/live_tinkering_web/templates/.*(eex)$},
      ~r{lib/live_tinkering_web/live/.*(ex)$}
    ]
  ]
```

Update your base web app file (for me, this is at `lib/live_tinkering_web.ex`). This is the file that has the various definitions for the Phoenix magic you get when you do something like `use LiveTinkeringWeb, :controller`.

In the definition for `view` -- so in `def view do ...` -- add this line within the `quote do ... end`, after aliasing the router.

```elixir
import Phoenix.LiveView, only: [live_render: 2, live_render: 3]
```

e.g, mine looks like:

```elixir
  def view do
    quote do
      use Phoenix.View,
        root: "lib/live_tinkering_web/templates",
        namespace: LiveTinkeringWeb

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import LiveTinkeringWeb.ErrorHelpers
      import LiveTinkeringWeb.Gettext
      alias LiveTinkeringWeb.Router.Helpers, as: Routes
      # this next line is the new bit
      import Phoenix.LiveView, only: [live_render: 2, live_render: 3]
    end
  end
```

## Code!

Okay, so setup is done.

Code time! _(Do note that I am doing literally zero error-handling, etc.)_

There are two things we need to do to make our clock in this case:

1. make a `live` module that will contain most of the code today
2. add a call to `live_render` to, well, render

### `ClockLive`

If you look in the `views` folder in your web app lib -- usually that is in a folder like `lib/<your_app_name>_web` -- you'll see a number of `.ex` files, all with names like `page_view.ex` or `error_view.ex`.

We want something similar, but in a folder parallel to it called `live`. So, once we have a folder called `lib/<your_app_name>_web/live`, let's go ahead and make our module in there. Just like we want files like `page_view.ex` for the `PageView` module in `views`, we want one called `ClockLive` here, and a file in that folder called `clock_live.ex`.

Our `ClockLive` module needs to do a few things:

1. `use Phoenix.LiveView`
2. implement `mount/2` (the callback for when the socket connects on page load)
3. implement `render/1`
4. implement some handlers -- `handle_info/2` and/or `handle_event/3`. We're just gonna use `handle_info/2` here.

(There are some rules about what will and won't trigger a rerender; I haven't gotten into those much because I haven't needed to thus far, but they are spelled out in the Phoenix docs for LiveView.)

#### `mount/2`

> When a view is rendered from the controller, the `mount/2` callback is invoked with the provided session data and the Live View's socket. The `mount/2` callback wires up socket assigns necessary for rendering the view.

This is where we start -- we get our socket, we get it all set up with any initialization we want. This is also where we set the timer -- we can check if the socket successfully connected, so it's a great/ideal place to get things set up.

__Your `mount/2` definition _must_ return `{:ok, socket}`. Anything else will be considered by the underlying code to be an indicator that Something Went Very Wrong in your app.__ (`assign/3` returns the socket, which is why the code below works.)

```elixir
  def mount(_session, socket) do
    if connected?(socket) do
      :timer.send_interval(1, self(), :update)
    end

    {:ok, assign(socket, :time, Time.utc_now)}
  end
```

_(You can't go smaller than 1 ms; I tried, it doesn't work. Not because of Phoenix, because of Erlang.)_

`:timer.send_interval(1, self(), :update)` says in plain-ish English: "every 1 (first argument) ms, send a message (`:update`, third argument) to ourselves (`self()`, second argument)." This will request an `:update` to our server every 1ms -- when our server receives that message, it will then re-evaluate our render and push that new content up to the client, where the page will show it.

FYI, `:update` is not a keyword or anything -- you could do `:update_timer`, `:tick`, `:meow`, etc. Any atom will work, as long as you use the same atom when you `handle_info`.

#### `handle_info/2`

The first parameter for this function is the message we want to handle -- in our case, we are sending an `:update` message up in `mount/2`, so here we want to match for that. (As with any other Elixir stuff, you don't _have_ to pattern match like this in the definition, but it's nice to because then you get an error if you receive a message you weren't expecting.)

The second parameter is the socket.

Just like in `mount/2`, Phoenix expects a certain kind of reply. Here, you should return a result of `{:noreply, socket}` -- anything else will be an error.

```elixir
  def handle_info(:update, socket) do
    {:noreply, assign(socket, :time, Time.utc_now)}
  end
```

(Remember -- `:update` is not a keyword, any atom will work, as long as you use the same atom in `mount` when you set the message in the timer. Pattern matching does require matching, after all!)

#### `render/1`

> After mounting, `render/1` is invoked and the HTML is sent as a regular HTML response to the client .... in the connected client case, a Live View process is spawned on the server, pushes the result of `render/1` to the client and continues on for the duration of the connection

> The `render/1` callback receives the `socket.assigns` and is responsible for returning rendered content. You can use `Phoenix.LiveView.sigil_L/2` to inline Live View templates.

`sigil_L` is the name of the function that we call by doing `~L{some content here}` -- other sigils you might know are ones like `~s`, `~T`, etc.

We're not going to do anything interesting here; just show the time we get from the server.

One note: `assigns` are in fact what we are `assign`ing to in the other functions by calling `assign(socket, :time, Time.utc_now)`, i.e. `socket.assigns`.

Since we did `assign(socket, :time, Time.utc_now)` we can access it using `@` by doing `@time`. If we'd done `assign(socket, :secret_message, "hello world")`, we would use `@secret_message` below where we wanted that secret message.

Just like in Eex, we use `<%= @time %>` to print out the time. That `=` is _very_ important -- if you don't have it, nothing will show up.

```elixir
  def render(assigns) do
    ~L{Current time: <%= @time %>}
  end
```

(Neat fact -- you can do different delimiters for the sigils. So you could do `~L"some secret thing"`, etc; there's a number of valid delimiters. It's handy if you want to use a different symbol because you're sick of having to escape a certain character.)

Here's what the whole live module looks like:

```elixir
defmodule LiveTinkeringWeb.ClockLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L{Current time: <%= @time %>}
  end

  def mount(_session, socket) do
    if connected?(socket) do
      :timer.send_interval(1, self(), :update)
    end

    {:ok, assign(socket, :time, Time.utc_now)}
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, :time, Time.utc_now)}
  end
end
```

### `live_render`

Last step: presumably, we'd like to, well, use and see the clock.

You can do this in other files as well, of course, I'm just using the basic index page because I'm lazy.

In `lib/<your_app>_web/templates/page/index.html.eex`, you can add this bit wherever; I just deleted everything in that file and replaced it with this:

```
<%= live_render(@conn, LiveTinkeringWeb.ClockLive) %>
```

---

...and that's it!

import React, {Component, PropTypes} from 'react'

class About extends Component {
  render() {
    return (
      <div>
        <div className="jumbotron">
          <h2>Welcome</h2>
          <p className="lead">
            On July 19, 2015, we started building a tool to easily look up public companies’ <a target="_blank" href="https://en.wikipedia.org/wiki/Price%E2%80%93earnings_ratio">P/E values</a> — over trailing 10 years.
          </p>
        </div>

        <p>Price-over-earning values are a very basic investment metric, but we see 3 fundamental problems with the way they are presented everywhere:</p>

        <ol>
          <li>If the number is negative almost no one will publish a negative P/E. They’ll just say N/A (not available).</li>
          <li>Almost all services will give you P/E values over trailing twelve months(ttm). That’s too little.</li>
          <li>At any given time, a lot can be happening with a firm’s accounting that severely distorts any metric, and P/E is surely one of them.</li>
        </ol>

        <p>Looking at a company’s development over 10 years can help value it more accurately. So we are starting with the most basic of all the metrics, P/E, and striving to make it instantaneous to look it up for any publicly listed company in the US, Europe and Brazil. Our vision is to do that right, and take it from there.</p>
        <br/>

        <h2>Technicalities</h2>
        <br/>
        <p>Look in Tens is being written using the super-high performance <a target="_blank" href="http://www.phoenixframework.org/">Phoenix</a> framework.</p>
        <p>Source code for this project is at <a target="_blank" href="https://github.com/1Poema/look-in-tens">{"https://github.com/1Poema/look-in-tens"}</a>.<br/>If you need consulting on Phoenix or Javascript, contact me at <a target="_blank" href="https://www.twitter.com/gusaiani">https://www.twitter.com/gusaiani</a> or via <a href="mailto:gustavo@poe.ma">email</a>.</p>
        <br/>

        <h3>Log</h3>
        <br/>

        <h5>2016 01 13 22:23</h5>
        <p>Implemented design.</p>
        <p>Moved all frontend markup to React.</p>

        <h5>2016 01 08 12:01</h5>
        <p>Suggestions based on search being returned</p>
        <p>Redux working</p>
        <p>JS testing implemented with Karma and Chai</p>
        <br/>

        <h5>2015 08 26 09:02</h5>
        <p>Integrated React.js</p>
        <br/>

        <h5>2015 08 19 11:51</h5>
        <p>Updated Phoenix to 0.17.0</p>
        <br/>

        <h5>2015 08 18 08:54</h5>
        <p>Added live reload to Phoenix Slim.</p>
        <p>Updated Phoenix Slim to 0.4.0</p>
        <br/>

        <h5>2015 08 06 17:58</h5>
        <p>Updated Phoenix to version 0.16.</p>
        <br/>

        <h5>2015 08 04 08:32</h5>
        <p>Saving companies to database, still without any treatment.</p>
        <br/>

        <h5><a name="monitor">2015 08 02 07:43</a></h5>
        <p>Set up a way to refresh Phoenix code any time I save a file in the editor and have it immediately available in a running iex session. <b>A live reloader for iex</b>, so to speak.</p>
        <p>This is really handy when you’re exploring inside the Phoenix application, and don’t want to keep restarting iex or really do anything except use what you just wrote.</p>
        <p>First, add a file to the root of your project, you can call it <code>.iex.exs</code> as in <a href="http://bit.ly/1ICIeKs" target="_blank">José Valim’s suggestion</a>, with the following code:</p>

        <pre>
          defmodule R do
            def reload! do
              Mix.Task.reenable "compile.elixir"
              Application.stop(Mix.Project.config[:app])
              Mix.Task.run "compile.elixir"
              Application.start(Mix.Project.config[:app], :permanent)
            end
          end
        </pre>

        <p>By running <code>$ iex -S mix</code> now, you can manually refresh the app inside <samp>iex</samp> with <code>> R.reload!</code>.</p>
        <br/>
          <p>Now onto having something listen for changes in the filesystem. There is a <a href="https://hex.pm/" target="_blank">Hex</a> package for that: <a href="https://github.com/falood/exfswatch" target="_blank">ExFSWatch</a> (thanks to Keita Kobayashi for this tip).</p>
          <p>Install ExFSWatch by adding it to your <code>mix.exs</code> dependencies:</p>
          <pre>
            def deps do
              {`[{:exfswatch, "~> 0.1.0"}]`}
            end
          </pre>

          <p>and running <code>$ mix deps.get</code>.</p>
          <p>List ExFSWatch as your application dependency:</p>

          <pre>
            def application do
              [applications: [:exfswatch]]
            end
          </pre>

          <p>I set up my filechange monitor in a new file I called <code>my_app/lib/my_app/monitor.ex</code>. Make sure to use your own application name instead of <code>my_app</code>. In it, I wrote:</p>

        <pre>
          defmodule Monitor do
            use ExFSWatch, dirs: ["../.."]
            <br/>
            def callback(:stop) do
              IO.puts "STOP"
            end
            <br/>
            def callback(file_path, events) do
              R.reload!
              {`IO.inspect {file_path, events}`}
            end
          end
        </pre>

        <p>Finally, I went back to file <code>.iex.exs</code> and added <code>Monitor.start</code> in the last line. Here’s what it looked like in the end:</p>

        <pre>
          defmodule R do
            def reload! do
              Mix.Task.reenable "compile.elixir"
              Application.stop(Mix.Project.config[:app])
              Mix.Task.run "compile.elixir"
              Application.start(Mix.Project.config[:app], :permanent)
            end
          end

          Monitor.start
        </pre>

        <p>That’s it. Next time you run an iex session in your Phoenix app, you can change project code on the fly, and just use it after merely saving the file in your text editor.</p>
        <p>As always, if you know how to do what I just did but better, please let me know on <a target="_blank" href="https://www.twitter.com/gusaiani">Twitter</a> or <a href="mailto:gustavo@poe.ma">email</a> and tell me if you want to be linked to in my thanks.</p>
        <br/>

        <h5>2015 08 01 20:52</h5>
        <p>Decided on data source for US companies’ ticker index.<br/>Bringing data into app with <a href="https://github.com/edgurgel/httpoison" target="_blank">HTTPoison</a>.
        <br/>
        Learned a way to reload files from inside a running iex session:</p>

        <pre>
          # add a file called .iex.exs in the root dir of your project
          # add code below
          defmodule R do
            def reload! do
              Mix.Task.reenable "compile.elixir"
              Application.stop(Mix.Project.config[:app])
              Mix.Task.run "compile.elixir"
              Application.start(Mix.Project.config[:app], :permanent)
            end
          end
        </pre>
        <br/>

        <h5>2015 07 31 08:55</h5>
        <p>Upgraded to Phoenix 0.15.</p>
        <br/>

        <h5>2015 07 25 23:14</h5>
        <p>
          After a successful automated population of data, learned how to clean the database.
          <br/>
          Did this by doing mix ecto.rollback, which loses all previous changes since the first migration, and a new mix ecto.migrate.
          <br/>
          Honestly could not find the equivalent of Rails’ rake db:reset or rake db:setup.
        </p>
        <br/>

        <h5>2015 07 22 22:43</h5>
        <p>
          Set up cron job using <a href="https://github.com/c-rack/quantum-elixir" target="_blank">Quantum</a>.
          <br/>
          Learned how to access a simple controller method from cron job.
          <br/>
          At this point, a new fake company should be created every minute at <a href="/companies">/companies</a>.
        </p>
        <br/>

        <h5>2015 07 21 09:07</h5>
        <p>
          Learned how to invoke IEx.pry
          <br/>
          Learned how to hard code a changeset.
          <br/>
          Learned how to generate a random string in Elixir.
          <br/>
          Learned how to store that random string as a new company name in companies#create.
        </p>
      </div>
    )
  }
}

export default About

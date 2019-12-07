React = require('react')

import { Link } from 'react-router-dom'

import LANG from '../lib/lang'

TopTable = (props) ->
        <table width="100%" className="top"><tbody>
            <tr>
                <td align="left" width="33%">
                    IJE: the Integrated Judging Environment
                </td>
                <td align="center" width="34%">
                    <font size="+1"><b>{props.name}</b></font>
                </td>
                <td width="33%" align="right">
                    <b>{props.status}</b>
                </td>
            </tr>
        </tbody></table>

HrefsTable = (props) ->
    w = Math.floor(100/(props.hrefs.length+3));

    <table width="100%" className="hrefs" cellSpacing="0"><tbody>
        <tr>
            {props.hrefs.map((href) ->
                inner = <Link to={href.href}>{LANG[href.text]}</Link>
                if not href.active
                    inner = <font className="disabled">{inner}</font>
                if props.curpage == href.href
                    inner = <b>{inner}</b>
                <td align="center" width={w + "%"} className="href" key={href.text}>
                    {inner}
                </td>
            )}
            <td className="login" width={3*w + "%"} align="center">
                {if login?
                    <span>{LANG.NotLoggedIn}
                        {has_contest && <span>[<Link to="/login">{LANG.LogIn}</Link>] [<Link to="/change_contest">{LANG.ChangeContest}</Link>]</span>}
                    </span>
                else
                    <span>{LANG.LoggedAsSbToSth(<b>{props.login}</b>, <b>{props.team_name}</b>)}. [<Link to="/logout">{LANG.LogOut}</Link>]</span>
                }
            </td>
        </tr>
    </tbody></table>

export default Sceleton = (Component) ->
    (props) ->
        # TODO
        contest_name = "name"
        status = "Status"
        has_contest = true
        curpage = "/"
        login = "QWE"
        team_name = "1234"
        hrefs=[
             {text: "Home", href: "/", active: true},
             {text: "Submit", href: "/submit", active: login?},
             {text: "Standings", href: "/standings", active: has_contest},
             {text: "Messages", href: "/messages", active: login?}
        ]
        <div>
            <TopTable name={contest_name} status={status}/>
            <HrefsTable hrefs={hrefs} curpage={curpage} has_contest={has_contest} login={login} team_name={team_name}/>
            <table width="100%" className="main"><tbody><tr><td>
                <Component/>
            </td></tr></tbody></table>
        </div>


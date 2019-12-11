React = require('react')

import { Link } from 'react-router-dom'

import LANG from '../lib/lang'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMe from '../lib/withMe'
import withContestData from '../lib/withContestData'

TopTable = (props) ->
        <table width="100%" className="top"><tbody>
            <tr>
                <td align="left" width="33%">
                    IJE: the Integrated Judging Environment
                </td>
                <td align="center" width="34%">
                    <font size="+1"><b>{props.contestData.title}</b></font>
                </td>
                <td width="33%" align="right">
                    <b>{props.contestData.status}, {LANG.TimeOfTime(props.contestData.time, props.contestData.length)}</b>
                </td>
            </tr>
        </tbody></table>

TopTable = withContestData(TopTable)

HrefsTable = (props) ->
    w = Math.floor(100/(props.hrefs.length+5));

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
            <td className="login" width={5*w + "%"} align="center">
                {if props.me.username?
                    <span>{LANG.LoggedAsSbToSth(<b>{props.me.username}: {props.me.name}</b>, <b>{props.me.contestTitle}</b>)}. [<Link to="/logout">{LANG.LogOut}</Link>]</span>
                else
                    <span>{LANG.NotLoggedIn}
                        <span> [<Link to="/login">{LANG.LogIn}</Link>] [<Link to="/changeContest">{LANG.ChangeContest}</Link>]</span>
                    </span>
                }
            </td>
        </tr>
    </tbody></table>

HrefsTable = withMe(HrefsTable)

export default Sceleton = (Component) ->
    (props) ->
        # TODO
        curpage = "/"
        hrefs=[
             {text: "Home", href: "/", active: true},
             {text: "Submit", href: "/submit", active: login?},
             {text: "Standings", href: "/standings", active: true},
             {text: "Messages", href: "/messages", active: login?}
        ]
        <div>
            <TopTable/>
            <HrefsTable hrefs={hrefs} curpage={curpage}/>
            <table width="100%" className="main"><tbody><tr><td>
                <Component/>
            </td></tr></tbody></table>
        </div>


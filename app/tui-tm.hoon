/-  homunculus, tlon-chat=chat, tlon-channels=channels
|%
::
+$  tlon-dms    (map ship dm:tlon-chat)
+$  tlon-clubs  (map id:club:tlon-chat club:tlon-chat)
::
+$  id  [ship=@p name=@t]
+$  channel
  $:  =id
      =posts:tlon-channels
  ==
+$  channels  (list channel)
+$  group
  $:  =channels
  ==
+$  groups  (map id group)
+$  state
  $:  active-group=$@(~ id)
      active-channel=@
      active-replies=(unit id-post:tlon-channels)
      =groups
  ==
+$  card  card:agent:gall
--
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  
=|  state
=*  state  -
^-  agent:gall
=<
|_  bol=bowl:gall
+*  this  .
++  on-init
  ^-  (quip card _this)
  =.  groups  (init-groups-state bol)
  :_  this
  :~  ~(full-update tui bol)
      ~(register tui bol)
  ==
++  on-save
  ^-  vase
  !>(~)
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =.  groups  (init-groups-state bol)
  :_  this
  :~  ~(full-update tui bol)
      ~(register tui bol)
  ==
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(our.bol src.bol)
  ?+  mark  !!
    ::
      %homunculus-event
    =/  eve  !<(event:homunculus vase)
    ?+  -.eve  !!
      ::
        %open
      :_  this
      :~  ~(full-update tui bol)
          ~(register tui bol)
      ==
      ::
        %select
      :: ~&  >>  eve
      [~ this]
      ::
        %act
      ?+  p.eve  !!
        ::
          [%deselect-group ~]
        =:  active-group    ~
            active-channel  ~
            active-replies  ~
          ==
        :_  this
        :~  ~(full-update tui bol)
        ==
        ::
          [%change-group @ta @ta ~]
        =.  active-group  [(slav %p i.t.p.eve) i.t.t.p.eve]
        :_  this
        :~  ~(change-group-update tui bol)
        ==
        ::
          [%change-channel @ta ~]
        =:  active-channel  (slav %ud i.t.p.eve)
            active-replies  ~
          ==
        :_  this
        :~  ~(change-channel-update tui bol)
        ==
        ::
          [%open-replies @ta ~]
        =.  active-replies  [~ (slav %da i.t.p.eve)]
        :_  this
        :~  ~(full-update tui bol)
        ==
        ::
          [%close-replies ~]
        =.  active-replies  ~
        :_  this
        :~  ~(full-update tui bol)
        ==
        ::
      ==
      ::
        %form
      ?+  p.eve  !!
        ::
          [%channel-form ~]
        [~ this]
        :: =/  data=@t       (~(got by q.eve) /channel-input)
        :: =/  chan=channel  (snag active-channel channels)
        :: =.  channel-messages.chan
        ::   %+  snoc  channel-messages.chan
        ::   =|  msg=channel-message
        ::   %_  msg
        ::     ship  our.bol
        ::     data  data
        ::   ==
        :: =.  channels  (snap channels active-channel chan)
        :: :_  this
        :: :~  ~(post-message-update tui bol)
        :: ==
        ::
      ==
      ::
    ==
    ::
  ==
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  
++  on-watch  |=(path ^-((quip card _this) !!))
++  on-leave  |=(path ^-((quip card _this) !!))
++  on-peek   |=(path ^-((unit (unit cage)) !!))
++  on-agent  |=([wire sign:agent:gall] ^-((quip card _this) !!))
++  on-arvo   |=([wire sign-arvo] ^-((quip card _this) !!))
++  on-fail   |=([term tang] ^-((quip card _this) !!))
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  
--
::
|%
::
++  tui
  |_  bol=bowl:gall
  ::
  ++  register
    ^-  card
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-register  !>(~)
    ==
  ::
  ++  full-update
    ^-  card
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-update  !>(`update:homunculus`~[[%element root]])
    ==
  ::
  ++  change-group-update
    ^-  card
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-update
        !>  ^-  update:homunculus
        :~  [%element root]
            [%set-scroll-position %p 100 /channel-content]
        ==
    ==
  ::
  ++  change-channel-update
    ^-  card
    ?>  ?=(^ active-group)
    =/  chans  channels:(~(got by groups) active-group)
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-update
        !>  ^-  update:homunculus
        :~  [%element (make-channel-list chans)]
            [%element (make-channel-panel chans)]
            [%set-scroll-position %p 100 /channel-content]
        ==
    ==
  ::
  ++  post-message-update
    ^-  card
    ?>  ?=(^ active-group)
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-update
        !>  ^-  update:homunculus
        :~  [%element (render-channel-content (snag active-channel channels:(~(got by groups) active-group)))]
            [%set-scroll-position %p 100 /channel-content]
        ==
    ==
  ::
  ++  root
    ^-  manx
    ;row(w "100%", h "100%", bg black, fg off-white)
      ;+  sidebar
      ;+  ?~  active-group
            inter-group-component
          intra-group-component
    ==
  ::
  ++  sidebar
    ^-  manx
    ;col(w "9", h "100%", bg black)
      ;select(w "100%", h "3", mt "1", b "arc", fx "center", select-fg green, bg dark-gray):"Groups"
      ;select(w "100%", h "3", mt "1", b "arc", fx "center", select-fg green):"DMs"
      ;select(w "100%", h "3", mt "1", b "arc", fx "center", select-fg green):"Profile"
    ==
  ::
  ++  inter-group-component
    ^-  manx
    ;row(w "grow", h "100%")
      ;+  group-list
    ==
  ::
  ++  group-list
    ^-  manx
    ;col/"group-list"(w "20%", h "100%", mx "1", bg black, b "arc", b-fg dark-gray)
      ;*  %+  turn  ~(tap in ~(key by groups))
          |=  =id
          ^-  manx
          ;col(w "100%")
            ;select/"change-group/{<ship.id>}/{(trip name.id)}"(w "100%", pl "1", fl "row", select-bg green)
              ;+  ;/  (trip name.id)
            ==
            ;line-h(fg dark-gray);
          ==
    ==
  ::
  ++  intra-group-component
    ^-  manx
    ?>  ?=(^ active-group)
    =/  grop=group  (~(got by groups) active-group)
    ;row(w "grow", h "100%")
      ;+  (make-channel-list channels.grop)
      ;+  (make-channel-panel channels.grop)
    ==
  ::
  ++  make-channel-list
    |=  =channels
    ^-  manx
    ?>  ?=(^ active-group)
    ;col/"channel-list"(w "20%", h "100%", mx "1", bg black, b "arc", b-fg dark-gray)
      ;+  (make-group-header name.active-group)
      ;line-h(fg dark-gray);
      ;*  %+  spun  channels
          |=  [i=channel a=@]
          :_  +(a)
          =/  is-active=?  =(a active-channel)
          ;col(w "100%")
            ;select/"change-channel/{(scow %ud a)}"(w "100%", pl "1", fl "row", select-bg green)
              =bg  ?:(is-active dark-gray black)
              ;+  ?:  is-active
                    ;/  "▶"
                  ;/  "▷"
              ;+  ;/  " {(trip name.id.i)}"
            ==
            ;line-h(fg dark-gray);
          ==
    ==
  ::
  ++  make-channel-panel
    |=  =channels
    ^-  manx
    =/  chan=channel  (snag active-channel channels)
    ;col/"channel-panel"(w "grow", h "100%", bg black)
      ;row(w "100%", h "1", fx "center"):"{(trip name.id.chan)}"
      ;col(w "100%", h "grow")
        ;*  ?~  active-replies  ~
            :_  ~
            ;layer(pr "1", py "1", fx "end")
              ;+  (make-replies-window posts.chan)
            ==
        ;+  (render-channel-content chan)
      ==
      ;form/"channel-form"(w "100%", h "5", fl "row", fx "center", fy "center")
        ;input/"channel-input"(w "36", h "3", mr "3", bg off-white);
        ;submit(w "3", h "1", px "1", select-fg green):"⮹"
      ==
    ==
  ::
  ++  render-channel-content
    |=  chan=channel
    ^-  manx
    ;scroll/"channel-content"(w "100%", h "100%", px "1", b "arc", b-fg dark-gray)
      ;*  %+  turn  (tap:((on id-post:tlon-channels (unit post:tlon-channels)) lte) posts.chan)
          |=  [=id-post:tlon-channels post=(unit post:tlon-channels)]
          ^-  manx
          ?~  post  ;null;
          ;col(w "100%", mb "1")
            ;row(w "100%", h "1")
              ;row(mr "1", fg "#8A808C"):"{<author.u.post>}"
              ;pattern(w "grow", h "1", fg dark-gray):"┈"
            ==
            ;row(w "100%")
              ;row(w "grow")
                ;+  (render-post-content content.u.post)
              ==
              ;col(ml "2")
                ;select/"open-replies/{<id-post>}"(px "1", bg dark-gray, select-fg green)
                  =fg  ?~(replies.u.post light-gray off-white)
                  ;+  ;/  ?~  replies.u.post  "Reply"
                          %+  weld
                            (scow %ud reply-count.reply-meta.u.post)
                          ?:  =(1 reply-count.reply-meta.u.post)
                            " reply"
                          " replies"
                ==
              ==
            ==
          ==
    ==
  ::
  ++  make-replies-window
    |=  channel-posts=posts:tlon-channels
    ^-  manx
    ?>  ?=(^ active-replies)
    =/  post=(unit post:tlon-channels)
      (got:((on id-post:tlon-channels (unit post:tlon-channels)) lte) channel-posts u.active-replies)
    ?~  post  ;null;
    ;col(w "50%", h "100%", px "1", bg dark-gray)
      ;border-t(fg gray)
        ;+  ;/  "█"
        ;pattern(w "grow", h "1"):"▀"
        ;+  ;/  "█"
      ==
      ;border-b(fg gray)
        ;+  ;/  "█"
        ;pattern(w "grow", h "1"):"▄"
        ;+  ;/  "█"
      ==
      ;border-l(fg gray)
        ;pattern(w "1", h "grow"):"█"
      ==
      ;border-r(fg gray)
        ;pattern(w "1", h "grow"):"█"
      ==
      ;row(w "100%", h "1", fx "end")
        ;select/"close-replies"(px "1", bg dark-gray, select-fg red, select-d "underline"):"close"
      ==
      ;scroll(w "100%", h "grow")
        ;row(fg "#b0aeac"):"{<author.u.post>}"
        ;+  (render-post-content content.u.post)
        ;line-h(my "1", fx "center")
          ;row(px "1"):"Replies"
        ==
        ;*  %+  turn  (tap:((on id-reply:tlon-channels (unit reply:tlon-channels)) lte) replies.u.post)
            |=  [id=id-reply:tlon-channels re=(unit reply:tlon-channels)]
            ?~  re  ;null;
            ;col(w "100%", mb "1")
              ;row(w "100%", h "1")
                ;row(mr "1", fg "#b0aeac"):"{<author.u.re>}"
                ;pattern(w "grow", h "1", fg gray):"┈"
              ==
              ;+  (render-post-content content.u.re)
            ==
      ==
      ;line-h(mb "1");
      ;form(w "100%", fx "center", fl "row")
        ;input(w "20", h "2", mr "1", bg off-white);
        ;submit(px "1", select-fg green):"⮹"
      ==
    ==
  ::
  ++  render-post-content
    |=  =story:tlon-channels
    ^-  manx
    ;col(w "100%")
      ;*  |-  ^-  marl
          ?~  story  ~
          :_  $(story t.story)
          ^-  manx
          ?-  -.i.story
            ::
              %block
            ?-  -.p.i.story       :: TODO: handle properly
              %image    ;row(w "100%"):"{(trip src.p.i.story)}"
              %cite     ;row;
              %header   ;row;
              %listing  ;row;
              %rule     ;row;
              %code     ;row(w "100%"):"{(trip code.p.i.story)}"
            ==
            ::
              %inline
            ;row(w "100%", fl "row-wrap")
              ;+  ;/  |-  ^-  tape           :: TODO: handle properly
                      ?~  p.i.story  ~
                      %+  weld
                        ^-  tape
                        ?@  i.p.i.story  (trip i.p.i.story)
                        ?-  -.i.p.i.story
                          %italics      $(p.i.story p.i.p.i.story)
                          %bold         $(p.i.story p.i.p.i.story)
                          %strike       $(p.i.story p.i.p.i.story)
                          %blockquote   $(p.i.story p.i.p.i.story)
                          %inline-code  (trip p.i.p.i.story)
                          %code         (trip p.i.p.i.story)
                          %ship         (scow %p p.i.p.i.story)
                          %block        (trip q.i.p.i.story)
                          %tag          (trip p.i.p.i.story)
                          %link         (trip p.i.p.i.story)
                          %task         $(p.i.story q.i.p.i.story)
                          %break        ~
                        ==
                      $(p.i.story t.p.i.story)
            ==
            ::
          ==
    ==
  ::
  ++  make-group-header
    |=  group-name=@t
    ^-  manx
    =;  [bg=tape fg=tape pat=tape]
      ;col(w "100%", h "11", bg bg)
        ;layer
          ;select/"deselect-group"(px "1", select-bg green):"<"
        ==
        ;layer(fx "center", fy "center")
          ;row(px "1"):"{(trip group-name)}"
        ==
        ;pattern(w "100%", h "100%", fg fg)
          ;+  ;/  pat
        ==
      ==
    ?+  (~(rad og group-name) 10)
      ::
      [black black " "]
      ::
        %0
      ["#738290" "#A1B5D8" "◞ "]
      ::
        %1
      ["#0B3C49" "#63ADF2" "⢎⡱"]
      ::
        %2
      ["#03440C" "#04773B" "○ "]
      ::
        %3
      ["#C37D92" "#E0C1B3" "◿◸◹◺"]
      ::
        %4
      ["#D78521" "#F2D398" "╷╵"]
      ::
        %5
      ["#650D1B" "#9B3D12" "△▽"]
      ::
        %6
      ["#171738" "#593C8F" "◠ "]
      ::
        %7
      ["#754668" "#BC96E6" "⢘⢨"]
      ::
        %8
      ["#13505B" "#0C7489" "◗◖ "]
      ::
        %9
      ["#2E4057" "#516a87" "◠◡"]
      ::
    ==
  ::
  ++  white             "#FFFFFF"
  ++  off-white         "#EFE6DD"
  ++  black             "#000000"
  ++  dark-gray         "#231F20"
  ++  gray              "#4c4345"
  ++  light-gray        "#6c5f63"
  ++  green             "#7EBDC2"
  ++  dark-blue         "#0B3C49"
  ++  light-blue        "#63ADF2"
  ++  red               "#BB4430"
  ::
  --
::
++  init-groups-state
  |=  bol=bowl:gall
  ^-  ^groups
  =+  .^(=channels:tlon-channels %gx /(scot %p our.bol)/channels/(scot %da now.bol)/v3/channels/full/noun)
  =/  chans=(list (pair nest:tlon-channels channel:tlon-channels))  ~(tap by channels)
  =|  grops=^groups
  |-  ^+  grops
  ?~  chans  grops
  =/  chan=channel
    :*  [ship.p.i.chans name.p.i.chans]
        posts.q.i.chans
    ==
  ~&  >   name.id.chan
  ~&  >>  ~(wyt by posts.chan)
  %=  $
    chans  t.chans
    grops
      %+  %~  put  by  grops
        group.perm.q.i.chans
      =/  grop  (~(get by grops) group.perm.q.i.chans)
      ?^  grop
        u.grop(channels [chan channels.u.grop])
      :*  [chan ~]
      ==
  ==
::
--


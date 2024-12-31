/-  homunculus, tlon-chat=chat, tlon-channels=channels, tlon-groups=groups
|%
::
+$  group-id    flag:tlon-groups
+$  channel-id  nest:tlon-channels
+$  name  @t
+$  channel
  $:  id=channel-id
      =name
      active-replies=(unit id-post:tlon-channels)
      =post-batch-start
      =posts:tlon-channels
  ==
+$  channels  (list channel)
+$  group
  $:  =name
      active-channel=@
      =channels
  ==
+$  groups  (map group-id group)
+$  state
  $:  active-group=$@(~ group-id)
      =groups
  ==
+$  card  card:agent:gall
::
+$  post-batch-start  $@(~ [index=@ id=id-post:tlon-channels])
++  post-batch-size   30
++  post-batch-jump   10
::
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
  =^  cards  groups  (init-groups-state bol)
  :_  this
  :*  ~(full-update tui bol)
      ~(register tui bol)
      cards
  ==
++  on-save
  ^-  vase
  !>(~)
++  on-load
  |=  old=vase
  ^-  (quip card _this)
  =^  cards  groups  (init-groups-state bol)
  :_  this
  :*  ~(full-update tui bol)
      ~(register tui bol)
      cards
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
        =.  active-group  ~
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
        ?>  ?=(^ active-group)
        =/  grop=group           (~(got by groups) active-group)
        =.  active-channel.grop  (slav %ud i.t.p.eve)
        =/  chan=channel         (snag active-channel.grop channels.grop)
        =.  active-replies.chan  ~
        =.  channels.grop        (snap channels.grop active-channel.grop chan)
        =.  groups               (~(put by groups) active-group grop)
        :_  this
        :~  (~(change-channel-update tui bol) chan grop)
        ==
        ::
          [%open-replies @ta ~]
        ?>  ?=(^ active-group)
        =/  grop=group           (~(got by groups) active-group)
        =/  chan=channel         (snag active-channel.grop channels.grop)
        =.  active-replies.chan  [~ (slav %da i.t.p.eve)]
        =.  channels.grop        (snap channels.grop active-channel.grop chan)
        =.  groups               (~(put by groups) active-group grop)
        :_  this
        :~  (~(toggle-replies-update tui bol) chan)
        ==
        ::
          [%close-replies ~]
        ?>  ?=(^ active-group)
        =/  grop=group           (~(got by groups) active-group)
        =/  chan=channel         (snag active-channel.grop channels.grop)
        =.  active-replies.chan  ~
        =.  channels.grop        (snap channels.grop active-channel.grop chan)
        =.  groups               (~(put by groups) active-group grop)
        :_  this
        :~  (~(toggle-replies-update tui bol) chan)
        ==
        ::
      ==
      ::
        %form
      ?+  p.eve  !!
        ::
          [%channel-post-form ~]
        ?>  ?=(^ active-group)
        =/  data=@t                (~(got by q.eve) /channel-post-input)
        =/  grop=group             (~(got by groups) active-group)
        =/  chan=channel           (snag active-channel.grop channels.grop)
        =/  post-total=@           ~(wyt by posts.chan)
        =/  batch-start-index=@    ?:((gth post-total post-batch-size) (sub post-total post-batch-size) 0)
        =/  batch-start-id         (get-batch-start-id batch-start-index posts.chan)
        =/  new-batch-start        `post-batch-start`?~(batch-start-id ~ [batch-start-index u.batch-start-id])
        ?:  =(post-batch-start.chan new-batch-start)
          :_  this
          :~  (make-channel-post-card id.chan data bol)
              (~(post-message-update tui bol) ~)
          ==
        =.  post-batch-start.chan  new-batch-start
        =.  channels.grop          (snap channels.grop active-channel.grop chan)
        =.  groups                 (~(put by groups) active-group grop)
        :_  this
        :~  (make-channel-post-card id.chan data bol)
            (~(post-message-update tui bol) chan)
        ==
        ::
          [%channel-reply-form ~]
        ?>  ?=(^ active-group)
        =/  data=@t                (~(got by q.eve) /channel-reply-input)
        =/  grop=group             (~(got by groups) active-group)
        =/  chan=channel           (snag active-channel.grop channels.grop)
        ?>  ?=(^ active-replies.chan)
        :_  this
        :~  (make-channel-reply-card id.chan u.active-replies.chan data bol)
            ~(post-reply-update tui bol)
        ==
        ::
      ==
      ::
        %scroll-trigger
      ?+  q.eve  !!
          [%channel-content ~]
        ?>  ?=(^ active-group)
        =/  =group    (~(got by groups) active-group)
        =/  =channel  (snag active-channel.group channels.group)
        =?  post-batch-start.channel
            ?=(^ post-batch-start.channel)
          (move-batch-start p.eve index.post-batch-start.channel posts.channel)
        =.  groups
          %+  %~  put  by  groups  active-group
          %_  group
            channels  (snap channels.group active-channel.group channel)
          ==
        :_  this
        :~  (~(channel-content-update tui bol) channel)
        ==
      ==
      ::
    ==
    ::
  ==
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  
++  on-watch  |=(path ^-((quip card _this) !!))
++  on-leave  |=(path ^-((quip card _this) !!))
++  on-peek   |=(path ^-((unit (unit cage)) !!))
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+  -.sign  [~ this]
    ::
      %fact
    ?+  pole  [~ this]
      ::
        [%channel group-ship=@ group-term=@ chan-kind=@ chan-ship=@ chan-name=@ ~]
      =/  g-id  (group-id [(slav %p group-ship.pole) group-term.pole])
      =/  update  !<(r-channels:tlon-channels q.cage.sign)
      ?+  -.r-channel.update  [~ this]  :: TODO: handle other cases
        ::
          %post
        =/  =group  (~(got by groups) g-id)
        =/  chan-index
          =|  i=@
          |-  ^-  (unit @)
          ?~  channels.group
            ~
          ?:  =(nest.update id.i.channels.group)
            [~ i]
          $(channels.group t.channels.group, i +(i))
        ?>  ?=(^ chan-index)
        ?+  -.r-post.r-channel.update  [~ this]
          ::
            %set
          =/  chan=channel    (snag u.chan-index channels.group)
          =.  posts.chan      (put:posts-on posts.chan id.r-channel.update post.r-post.r-channel.update)
          =.  channels.group  (snap channels.group u.chan-index chan)
          =.  groups          (~(put by groups) g-id group)
          ?.  ?&  =(g-id active-group)
                  =(u.chan-index active-channel.group)
              ==
            [~ this]
          :_  this
          :~  (~(channel-content-update tui bol) chan)  :: TODO: only render if on the end batch
          ==
          ::
            %reply
          ?+  -.r-reply.r-post.r-channel.update  [~ this]
            ::
              %set
            =/  chan=channel         (snag u.chan-index channels.group)
            =/  parent-post          (got:posts-on posts.chan id.r-channel.update)
            =?  parent-post
                ?=(^ parent-post)
              %_  parent-post
                reply-count.reply-meta.u
                  +(reply-count.reply-meta.u.parent-post)
                replies.u
                  %^    put:replies-on
                      replies.u.parent-post
                    id.r-post.r-channel.update
                  reply.r-reply.r-post.r-channel.update
              ==
            =.  posts.chan           (put:posts-on posts.chan id.r-channel.update parent-post)
            =.  channels.group       (snap channels.group u.chan-index chan)
            =.  groups               (~(put by groups) g-id group)
            ?.  ?&  =(g-id active-group)
                    =(u.chan-index active-channel.group)
                ==
              [~ this]
            :_  this
            ?~  active-replies.chan
              :~  (~(channel-content-update tui bol) chan)
              ==
            :~  (~(replies-update tui bol) ?>(?=(^ parent-post) u.parent-post))
            ==
            ::
          ==
          ::
        ==
        ::
      ==
      ::
    ==
    ::
  ==
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  
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
  ++  make-update-card
    |=  =update:homunculus
    ^-  card
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-update  !>(update)
    ==
  ::
  ++  full-update
    ^-  card
    %-  make-update-card
    :~  [%element root]
    ==
  ::
  ++  change-group-update
    ^-  card
    %-  make-update-card
    :~  [%element root]
        [%set-scroll-position %p 100 /channel-content]
    ==
  ::
  ++  change-channel-update
    |=  [chan=channel grop=group]
    ^-  card
    %-  make-update-card
    :~  [%element (make-channel-list grop)]
        [%element (make-channel-panel chan)]
        [%set-scroll-position %p 100 /channel-content]
    ==
  ::
  ++  toggle-replies-update
    |=  chan=channel
    ^-  card
    %-  make-update-card
    :~  [%element (make-channel-panel chan)]
    ==
  ::
  ++  post-message-update
    |=  maybe-chan=$@(~ channel)
    ^-  card
    %-  make-update-card
    ?^  maybe-chan
      :~  [%element (render-channel-content maybe-chan)]
          [%set-scroll-position %p 100 /channel-content]
      ==
    :~  [%set-scroll-position %p 100 /channel-content]
    ==
  ::
  ++  post-reply-update
    ^-  card
    %-  make-update-card
    :~  [%set-scroll-position %p 100 /replies-content]
    ==
  ::
  ++  channel-content-update
    |=  =channel
    ^-  card
    %-  make-update-card
    :~  [%element (render-channel-content channel)]
    ==
  ::
  ++  replies-update
    |=  parent-post=post:tlon-channels
    ^-  card
    %-  make-update-card
    :~  [%element (render-replies-content parent-post)]
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
      ;*  %+  turn  ~(tap by groups)
          |=  [=group-id =group]
          ^-  manx
          ;col(w "100%")
            ;select/"change-group/{<p.group-id>}/{(trip q.group-id)}"(w "100%", pl "1", fl "row", select-bg green)
              ;+  ;/  (trip name.group)
            ==
            ;line-h(fg dark-gray);
          ==
    ==
  ::
  ++  intra-group-component
    ^-  manx
    ?>  ?=(^ active-group)
    =/  grop=group    (~(got by groups) active-group)
    =/  chan=channel  (snag active-channel.grop channels.grop)
    ;row(w "grow", h "100%")
      ;+  (make-channel-list grop)
      ;+  (make-channel-panel chan)
    ==
  ::
  ++  make-channel-list
    |=  grop=group
    ^-  manx
    ;col/"channel-list"(w "20%", h "100%", mx "1", bg black, b "arc", b-fg dark-gray)
      ;+  (make-group-header name.grop)
      ;line-h(fg dark-gray);
      ;*  %+  spun  channels.grop
          |=  [i=channel a=@]
          :_  +(a)
          =/  is-active=?  =(a active-channel.grop)
          ;col(w "100%")
            ;select/"change-channel/{(scow %ud a)}"(w "100%", pl "1", fl "row", select-bg green)
              =bg  ?:(is-active dark-gray black)
              ;+  ?:  is-active
                    ;/  "▶"
                  ;/  "▷"
              ;+  ;/  " {(trip name.i)}"
            ==
            ;line-h(fg dark-gray);
          ==
    ==
  ::
  ++  make-channel-panel
    |=  chan=channel
    ^-  manx
    ;col/"channel-panel"(w "grow", h "100%", bg black)
      ;row(w "100%", h "1", fx "center"):"{(trip name.chan)}"
      ;col(w "100%", h "grow")
        ;*  ?~  active-replies.chan  ~
            :_  ~
            =/  parent-post  (got:posts-on posts.chan u.active-replies.chan)
            ;layer(pr "1", py "1", fx "end")
              ;+  (render-replies-window parent-post)
            ==
        ;+  (render-channel-content chan)
      ==
      ;form/"channel-post-form"(w "100%", h "5", fl "row", fx "center", fy "center")
        ;input/"channel-post-input"(w "36", h "3", mr "3", bg off-white);
        ;submit(w "3", h "1", px "1", select-fg green):"⮹"
      ==
    ==
  ::
  ++  render-channel-content
    |=  chan=channel
    ^-  manx
    ;scroll/"channel-content"(w "100%", h "100%", px "1", b "arc", b-fg dark-gray, trigger "1")
      ;*  %+  turn  (get-posts-to-render chan)
          |=  [=id-post:tlon-channels post=(unit post:tlon-channels)]
          ^-  manx
          ?~  post  ;null;
          =/  id=tape  (scow %da id-post)
          ;col/"post/{id}"(w "100%", mb "1")
            ;row(w "100%", h "1")
              ;row(mr "1", fg "#8A808C"):"{<author.u.post>}"
              ;pattern(w "grow", h "1", fg dark-gray):"┈"
            ==
            ;row(w "100%")
              ;row(w "grow")
                ;+  (render-post-content content.u.post)
              ==
              ;col(ml "2")
                ;select/"open-replies/{id}"(px "1", bg dark-gray, select-fg green)
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
  ++  render-replies-window
    |=  parent-post=(unit post:tlon-channels)
    ^-  manx
    ?~  parent-post  ;null;
    ;col/"replies-window"(w "50%", h "100%", px "1", bg dark-gray)
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
      ;+  (render-replies-content u.parent-post)
      ;line-h(mb "1");
      ;form/"channel-reply-form"(w "100%", fx "center", fl "row")
        ;input/"channel-reply-input"(w "20", h "2", mr "1", bg off-white);
        ;submit(px "1", select-fg green):"⮹"
      ==
    ==
  ::
  ++  render-replies-content
    |=  parent-post=post:tlon-channels
    ^-  manx
    ;scroll/"replies-content"(w "100%", h "grow")
      ;row(fg "#b0aeac"):"{<author.parent-post>}"
      ;+  (render-post-content content.parent-post)
      ;line-h(my "1", fx "center")
        ;row(px "1"):"Replies"
      ==
      ;*  %+  turn  (tap:replies-on replies.parent-post)
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
++  transform-cord-to-memo
  |=  [=cord bol=bowl:gall]
  ^-  memo:tlon-channels
  :_  [our.bol now.bol]
  :_  ~
  :-  %inline
  :~  cord
      [%break ~]
  ==
::
++  make-channel-post-card
  |=  [=channel-id data=@t bol=bowl:gall]
  ^-  card
  =/  kin=@ta  kind.channel-id
  =/  sip=@ta  (scot %p ship.channel-id)
  =/  nam=@ta  name.channel-id
  =/  =memo:tlon-channels  (transform-cord-to-memo data bol)
  =/  post-action=a-channels:tlon-channels
    :*  %channel  channel-id  %post
        %add  [memo [%chat ~]]
    ==
  :*  %pass  /post/[kin]/[sip]/[nam]  %agent  [our.bol %channels]
      %poke  %channel-action  !>(post-action)
  ==
::
++  make-channel-reply-card
  |=  [=channel-id post-id=id-post:tlon-channels data=@t bol=bowl:gall]
  ^-  card
  =/  kin=@ta  kind.channel-id
  =/  sip=@ta  (scot %p ship.channel-id)
  =/  nam=@ta  name.channel-id
  =/  =memo:tlon-channels  (transform-cord-to-memo data bol)
  =/  post-action=a-channels:tlon-channels
    :*  %channel  channel-id  %post
        %reply  post-id
        %add  memo
    ==
  :*  %pass  /reply/(scot %da post-id)/[kin]/[sip]/[nam]  %agent  [our.bol %channels]
      %poke  %channel-action  !>(post-action)
  ==
::
++  make-channel-subscription-card
  |=  [=group-id =channel-id bol=bowl:gall]
  ^-  card
  =/  gip=@ta  (scot %p p.group-id)
  =/  ter=@ta  q.group-id
  =/  kin=@ta  kind.channel-id
  =/  cip=@ta  (scot %p ship.channel-id)
  =/  nam=@ta  name.channel-id
  :*  %pass  /channel/[gip]/[ter]/[kin]/[cip]/[nam]  %agent  [our.bol %channels]
      %watch  /v1/[kin]/[cip]/[nam]
  ==
::
++  init-groups-state
  |=  bol=bowl:gall
  ^-  (quip card ^groups)
  =+  .^(=channels:tlon-channels %gx /(scot %p our.bol)/channels/(scot %da now.bol)/v3/channels/full/noun)
  =+  .^(=groups-ui:tlon-groups %gx /(scot %p our.bol)/groups/(scot %da now.bol)/groups/v1/groups-ui)
  =/  chans=(list (pair nest:tlon-channels channel:tlon-channels))  ~(tap by channels)
  =|  grops=^groups
  =|  cards=(list card)
  |-  ^-  (quip card ^groups)
  ?~  chans
    cards^grops
  =/  post-total=@           ~(wyt by posts.q.i.chans)
  =/  batch-start-index=@    ?:((gth post-total post-batch-size) (sub post-total post-batch-size) 0)
  =/  batch-start-id         (get-batch-start-id batch-start-index posts.q.i.chans)
  =/  grop-ui                (~(get by groups-ui) group.perm.q.i.chans)
  ?~  grop-ui
    ~&  >>>  'tui-messenger init error: group data not found for a channel'
    $(chans t.chans)
  =/  chan-ui                (~(get by channels.u.grop-ui) p.i.chans)
  =|  chan=channel
  =:  id.chan                p.i.chans
      name.chan              ?^(chan-ui title.meta.u.chan-ui name.p.i.chans)
      post-batch-start.chan  ?~(batch-start-id ~ [batch-start-index u.batch-start-id])
      posts.chan             posts.q.i.chans
    ==
  %=  $
    chans  t.chans
    cards  [(make-channel-subscription-card group.perm.q.i.chans id.chan bol) cards]
    grops
      %+  %~  put  by  grops  group.perm.q.i.chans
      =/  grop  (~(get by grops) group.perm.q.i.chans)
      ?^  grop
        u.grop(channels [chan channels.u.grop])
      =|  new-grop=group
      %_  new-grop
        name      title.meta.u.grop-ui
        channels  [chan ~]
      ==
  ==
::
++  get-batch-start-id
  |=  [batch-start-index=@ =posts:tlon-channels]
  ^-  (unit id-post:tlon-channels)
  ?~  posts  ~
  :-  ~
  =<  ->
  %^    %-  dip:posts-on
        ,[@ud id-post:tlon-channels]
      posts
    [0 key.head:(pop:posts-on posts)]
  |=  $:  [i=@ud id=id-post:tlon-channels]
          k=id-post:tlon-channels
          v=(unit post:tlon-channels)
      ==
  ^-  $:  (unit (unit post:tlon-channels))
          ?
          [@ud id-post:tlon-channels]
      ==
  :-  [~ v]
  ?:  =(i batch-start-index)
    [& i k]
  [| +(i) id]
::
++  move-batch-start
  |=  [direction=?(%up %down) batch-start-index=@ =posts:tlon-channels]
  ^-  post-batch-start
  =;  new-index=@
    =/  new-id  (get-batch-start-id new-index posts)
    ?~  new-id  ~
    [new-index u.new-id]
  ?-  direction
    ::
      %up
    ?:((gth batch-start-index post-batch-jump) (sub batch-start-index post-batch-jump) 0)
    ::
      %down
    =/  post-total=@  ~(wyt by posts)
    =/  max-index=@   ?:((gth post-total post-batch-size) (sub post-total post-batch-size) 0)
    (min max-index (add post-batch-jump batch-start-index))
    ::
  ==
::
++  get-posts-to-render
  |=  =channel
  ^-  (list [id-post:tlon-channels (unit post:tlon-channels)])
  ?~  posts.channel  ~
  ?~  post-batch-start.channel
    (tab:posts-on posts.channel ~ post-batch-size)
  :-  [id.post-batch-start.channel (got:posts-on posts.channel id.post-batch-start.channel)]
  (tab:posts-on posts.channel [~ id.post-batch-start.channel] post-batch-size)
::
++  posts-on    ((on id-post:tlon-channels (unit post:tlon-channels)) lte)
++  replies-on  ((on id-reply:tlon-channels (unit reply:tlon-channels)) lte)
::
--


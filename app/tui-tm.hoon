/-  homunculus
|%
+$  channels  (list channel)
+$  channel
  $:  name=@t
      =channel-messages
  ==
+$  channel-messages  (list channel-message)
+$  channel-message
  $:  replies=(list message)
      message
  ==
+$  message
  $:  =ship
      data=@t
  ==
+$  state
  $:  active-channel=@
      active-replies=(unit @)
      =channels
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
  =.  channels
    :~  init-channel--internet-cafe
        init-channel--support
    ==
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
  =.  channels
    :~  init-channel--internet-cafe
        init-channel--support
    ==
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
          [%change-channel @ta ~]
        =:  active-channel  (slav %ud i.t.p.eve)
            active-replies  ~
          ==
        :_  this
        :~  ~(change-channel-update tui bol)
        ==
        ::
          [%open-replies @ta ~]
        =.  active-replies  [~ (slav %ud i.t.p.eve)]
        :_  this
        :~  ~(full-update tui bol)
        ==
        ::
          [%close-replies @ta ~]
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
        =/  data=@t       (~(got by q.eve) /channel-input)
        =/  chan=channel  (snag active-channel channels)
        =.  channel-messages.chan
          %+  snoc  channel-messages.chan
          =|  msg=channel-message
          %_  msg
            ship  our.bol
            data  data
          ==
        =.  channels  (snap channels active-channel chan)
        :_  this
        :~  ~(post-message-update tui bol)
        ==
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
  ++  change-channel-update
    ^-  card
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-update
        !>  ^-  update:homunculus
        :~  [%element channel-list]
            [%element channel-panel]
            [%set-scroll-position %p 100 /channel-content]
        ==
    ==
  ::
  ++  post-message-update
    ^-  card
    :*  %pass  /homunculus  %agent  [our.bol %homunculus]
        %poke  %homunculus-update
        !>  ^-  update:homunculus
        :~  [%element (render-channel-content (snag active-channel channels))]
            [%set-scroll-position %p 100 /channel-content]
        ==
    ==
  ::
  ++  root
    ^-  manx
    ;row(w "100%", h "100%", bg black, fg off-white)
      ;+  sidebar
      ;+  channel-list
      ;+  channel-panel
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
  ++  channel-list
    ^-  manx
    ;col/"channel-list"(w "20%", h "100%", mx "1", bg black, b "arc", b-fg dark-gray)
      ;col(w "100%", h "11", bg dark-blue)
        ;layer(fx "center", fy "center")
          ;row(px "1", fg off-white):"Tlon Local"
        ==
        ;pattern(w "100%", h "100%", fg light-blue):"⢎⡱"
      ==
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
              ;+  ;/  " {(trip name.i)}"
            ==
            ;line-h(fg dark-gray);
          ==
    ==
  ::
  ++  channel-panel
    ^-  manx
    =/  chan=channel  (snag active-channel channels)
    ;col/"channel-panel"(w "grow", h "100%", bg black)
      ;row(w "100%", h "1", fx "center"):"{(trip name.chan)}"
      ;col(w "100%", h "grow")
        ;*  ?~  active-replies  ~
            :_  ~
            ;layer(pr "1", py "1", fx "end")
              ;+  replies-window
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
      ;*  %+  spun  channel-messages.chan
          |=  [msg=channel-message i=@]
          ^-  [manx @]
          :_  +(i)
          ;col(w "100%", mb "1")
            ;row(w "100%", h "1")
              ;row(mr "1", fg "#8A808C"):"{<ship.msg>}"
              ;pattern(w "grow", h "1", fg dark-gray):"┈"
            ==
            ;row(w "100%")
              ;row(w "grow"):"{(trip data.msg)}"
              ;col(ml "2")
                ;select/"open-replies/{<i>}"(px "1", bg dark-gray, select-fg green)
                  =fg  ?~(replies.msg light-gray off-white)
                  ;+  ;/  ?~(replies.msg "Reply" "{(scow %ud (lent replies.msg))} replies")
                ==
              ==
            ==
          ==
    ==
  ::
  ++  replies-window
    ^-  manx
    ?>  ?=(^ active-replies)
    =/  main-msg=channel-message
      (snag u.active-replies channel-messages:(snag active-channel channels))
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
        ;select/"close-replies/{<u.active-replies>}"(px "1", bg dark-gray, select-fg red, select-d "underline"):"close"
      ==
      ;scroll(w "100%", h "grow")
        ;row(fg "#b0aeac"):"{<ship.main-msg>}"
        ;+  ;/  (trip data.main-msg)
        ;line-h(my "1", fx "center")
          ;row(px "1"):"Replies"
        ==
        ;*  %+  turn  replies.main-msg
            |=  msg=message
            ;col(w "100%", mb "1")
              ;row(w "100%", h "1")
                ;row(mr "1", fg "#b0aeac"):"{<ship.msg>}"
                ;pattern(w "grow", h "1", fg gray):"┈"
              ==
              ;+  ;/  (trip data.msg)
            ==
      ==
      ;line-h(mb "1");
      ;form(w "100%", fx "center", fl "row")
        ;input(w "20", h "2", mr "1", bg off-white);
        ;submit(px "1", select-fg green):"⮹"
      ==
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
++  init-channel--internet-cafe
  ^-  channel
  =|  chan=channel
  =|  chan-msg=channel-message
  %_  chan
    name  'Internet Cafe'
    channel-messages
      :~  chan-msg(ship ~pet, data 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ultricies malesuada mi, id fringilla massa. Vestibulum semper metus sit amet nunc iaculis, eu rutrum massa faucibus.')
          chan-msg(ship ~sun, data 'Sed hendrerit nulla quis erat faucibus dignissim.')
          chan-msg(ship ~bus, data 'Nunc nulla nulla, pharetra non malesuada vitae, vulputate quis metus. Maecenas ac sodales erat, et venenatis orci. Cras eleifend arcu risus, id porta odio egestas vitae. Nulla tortor lectus, semper at risus at, mattis cursus tellus.')
          chan-msg(ship ~fur, data 'Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In hac habitasse platea dictumst. Nullam et varius mi. Interdum et malesuada fames ac ante ipsum primis in faucibus. Duis ac urna et massa ultrices lacinia. Donec vitae cursus sem. Phasellus leo sapien, pellentesque nec iaculis ut, posuere eu nibh. Pellentesque convallis erat sit amet nisl imperdiet, vitae blandit elit blandit.')
          chan-msg(ship ~fed, data 'Cras in posuere ex, ac tincidunt ligula. Donec eros metus, pharetra non facilisis quis, faucibus quis enim.')
          chan-msg(ship ~fur, data 'Maecenas euismod nunc nec mauris euismod luctus. Quisque tincidunt id libero euismod sollicitudin. Praesent consectetur quam a neque rutrum semper vel a metus. Phasellus quis ornare ligula. Mauris diam nunc, tempus non arcu vitae, rutrum facilisis metus.')
          chan-msg(ship ~pet, data 'Quisque a lacinia nunc.')
          chan-msg(ship ~bus, data 'Suspendisse et venenatis erat. Sed id porttitor odio. Aliquam laoreet nisi quis ante laoreet, vel venenatis metus dignissim. Nam libero tellus, hendrerit a lacus eu, commodo volutpat dolor. Fusce dapibus, justo eu hendrerit elementum, nulla odio mollis mauris, eget sagittis purus nulla vel turpis. Aliquam ornare nunc ligula, non mattis tortor congue ullamcorper. Pellentesque non posuere neque. Sed facilisis, nisl vitae gravida elementum, orci arcu auctor ipsum, sed dignissim purus metus cursus massa. Quisque eget felis cursus, posuere libero at, mollis nisl.')
          chan-msg(ship ~bel, data 'Cras at mauris vel libero pharetra laoreet. Nunc ultricies et purus in tempor. Suspendisse volutpat justo eget justo lacinia, vitae interdum lacus laoreet.')
          %_  chan-msg
            ship  ~pet
            data  'Ut eu condimentum sapien, et imperdiet lacus. Phasellus eu urna nec neque lacinia tincidunt. Proin tincidunt nisl vitae magna vehicula, a mollis felis tristique. Vestibulum vel urna laoreet lacus tristique cursus vel tristique leo.'
            replies
              :~  [~fed 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.']
                  [~sun 'Aliquam tempus elit velit, mattis rutrum lectus molestie sit amet. Sed facilisis, dui semper pulvinar placerat, erat purus euismod mauris, et vestibulum diam ex et dui. Mauris euismod arcu mauris. Curabitur pulvinar faucibus purus vel fermentum.']
                  [~fur 'In a pellentesque magna. Aenean pharetra leo leo, quis ullamcorper augue tincidunt vitae. Curabitur sed tincidunt ipsum, ac laoreet lacus. Etiam a vehicula ipsum. Duis et lectus purus. Donec eget dui imperdiet est venenatis suscipit faucibus imperdiet lacus. Duis vestibulum pharetra magna, eget posuere nisl ultricies cursus.']
                  [~bel 'Fusce ornare congue quam, mollis consequat nibh iaculis id. Curabitur mattis lacinia enim, a accumsan augue finibus eu. Praesent aliquam quis quam at tempor.']
                  [~pet 'Sed blandit quam nunc, id scelerisque lorem ultrices ac.']
                  [~fur 'Suspendisse et venenatis erat. Sed id porttitor odio. Aliquam laoreet nisi quis ante laoreet, vel venenatis metus dignissim. Nam libero tellus, hendrerit a lacus eu, commodo volutpat dolor. Fusce dapibus, justo eu hendrerit elementum, nulla odio mollis mauris, eget sagittis purus nulla vel turpis. Aliquam ornare nunc ligula, non mattis tortor congue ullamcorper. Pellentesque non posuere neque. Sed facilisis, nisl vitae gravida elementum, orci arcu auctor ipsum, sed dignissim purus metus cursus massa. Quisque eget felis cursus, posuere libero at, mollis nisl.']
                  [~bus 'Proin quis dui ut est blandit tristique.']
              ==
          ==
      ==
  ==
::
++  init-channel--support
  ^-  channel
  =|  chan=channel
  =|  chan-msg=channel-message
  %_  chan
    name  'Support'
    channel-messages
      :~  %_  chan-msg
            ship  ~bus
            data  'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.'
            replies
              :~  [~pet 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ultricies malesuada mi, id fringilla massa. Vestibulum semper metus sit amet nunc iaculis, eu rutrum massa faucibus. Sed hendrerit nulla quis erat faucibus dignissim. Nunc nulla nulla, pharetra non malesuada vitae, vulputate quis metus. Maecenas ac sodales erat, et venenatis orci. Cras eleifend arcu risus, id porta odio egestas vitae. Nulla tortor lectus, semper at risus at, mattis cursus tellus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ultricies malesuada mi, id fringilla massa. Vestibulum semper metus sit amet nunc iaculis, eu rutrum massa faucibus. Sed hendrerit nulla quis erat faucibus dignissim. Nunc nulla nulla, pharetra non malesuada vitae, vulputate quis metus. Maecenas ac sodales erat, et venenatis orci. Cras eleifend arcu risus, id porta odio egestas vitae. Nulla tortor lectus, semper at risus at, mattis cursus tellus.']
                  [~bus 'Pellentesque porttitor pretium ligula, vitae pharetra nisi elementum at.']
              ==
          ==
      ==
  ==
::
--


/*
  ===============================================
  DCC831 Formal Methods
  2023.2

  Mini Project 2 - Part A

  Your name: Guilherme de Oliveira Silva
  ===============================================
*/


function rem<T(==)>(x: T, s: seq<T>): seq<T>
  ensures x !in rem(x, s)
  ensures forall i :: 0 <= i < |rem(x, s)| ==> rem(x, s)[i] in s
  ensures forall i :: 0 <= i < |s| && s[i] != x ==> s[i] in rem(x, s)
{}


// The next three classes have a minimal class definition,
// for simplicity
class Address
{}

class Date
{}

class MessageId
{}

//==========================================================
//  Message
//==========================================================
class Message
{
  var id: MessageId
  var content: string
  var date: Date
  var sender: Address
  var recipients: seq<Address>

  constructor (s: Address)
    ensures fresh(id)
    ensures fresh(date)
    ensures content == ""
    ensures sender == s
    ensures recipients == []
  {}

  method setContent(c: string)
    modifies this
    ensures content == c
  {}

  method setDate(d: Date)
    modifies this
    ensures date == d
  {}

  method addRecipient(p: nat, r: Address)
    modifies this
    requires p < |recipients|
    ensures |recipients| == |old(recipients)| + 1
    ensures recipients[p] == r
    ensures forall i :: 0 <= i < p ==> recipients[i] == old(recipients[i])
    ensures forall i :: p < i < |recipients| ==> recipients[i] == old(recipients[i-1])
  {}
}

//==========================================================
//  Mailbox
//==========================================================
// Each Mailbox has a name, which is a string. Its main content is a set of messages.
class Mailbox {
  var messages: set<Message>
  var name: string

  // Creates an empty mailbox with name n
  constructor (n: string)
    ensures name == n
    ensures messages == {}
  {}

  // Adds message m to the mailbox
  method add(m: Message)
    modifies this
    ensures m in messages
    ensures messages == old(messages) + {m}
  {}

  // Removes message m from mailbox. m must not be in the mailbox.
  method remove(m: Message)
    modifies this
    requires m in messages
    ensures m !in messages
    ensures messages == old(messages) - {m}
  {}

  // Empties the mailbox messages
  method empty()
    modifies this
    ensures messages == {}
  {}
}

//==========================================================
//  MailApp
//==========================================================
class MailApp {
  // abstract field for user defined boxes
  ghost var userboxes: set<Mailbox>

  // the inbox, drafts, trash and sent are both abstract and concrete
  var inbox: Mailbox
  var drafts: Mailbox
  var trash: Mailbox
  var sent: Mailbox

  // userboxList implements userboxes
  var userboxList: seq<Mailbox>

  // Class invariant
  ghost predicate Valid()
    reads this
  {}

  constructor ()
  {}

  // Deletes user-defined mailbox mb
  method deleteMailbox(mb: Mailbox)
    requires Valid()
    requires mb in userboxList
    // ensures mb !in userboxList
  {}

  // Adds a new mailbox with name n to set of user-defined mailboxes
  // provided that no user-defined mailbox has name n already
  method newMailbox(n: string)
    modifies this
    requires Valid()
    requires !exists mb | mb in userboxList :: mb.name == n
    ensures exists mb | mb in userboxList :: mb.name == n
  {}

  // Adds a new message with sender s to the drafts mailbox
  method newMessage(s: Address)
    modifies this.drafts
    requires Valid()
    ensures exists m | m in drafts.messages :: m.sender == s
  {}

  // Moves message m from mailbox mb1 to a different mailbox mb2
  method moveMessage (m: Message, mb1: Mailbox, mb2: Mailbox)
    modifies mb1, mb2
    requires Valid()
    requires m in mb1.messages
    requires m !in mb2.messages
    ensures m !in mb1.messages
    ensures m in mb2.messages
  {}

  // Moves message m from mailbox mb to the trash mailbox provided
  // that mb is not the trash mailbox
  method deleteMessage (m: Message, mb: Mailbox)
    modifies m, mb, this.trash
    requires Valid()
    requires m in mb.messages
    requires m !in trash.messages
  {}

  // Moves message m from the drafts mailbox to the sent mailbox
  method sendMessage(m: Message)
    modifies this.drafts, this.sent
    requires Valid()
    requires m in drafts.messages
    requires m !in sent.messages
  {}

  // Empties the trash mailbox
  method emptyTrash()
    modifies this.trash
    requires Valid()
    ensures trash.messages == {}
  {}
}


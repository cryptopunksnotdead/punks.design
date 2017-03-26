import React from 'react';


import Card from './Card.js';

export default class Game extends React.Component {

  constructor( props ) {
    super( props );

    // unshuffled card keys (that is, num+group e.g. 1A, 2A, 1B, etc.)
    this.cardKeys = [
        [1,'A'],[2,'A'],[3,'A'],[4,'A'],[5,'A'],[6,'A'],[7,'A'],[8,'A'],
        [1,'B'],[2,'B'],[3,'B'],[4,'B'],[5,'B'],[6,'B'],[7,'B'],[8,'B'],
      ];

    const cardStates = this.cardKeys.map( key => {
      return {
        num:     key[0],
        group:   key[1],
        flipped: false,
        matched: false        //   use matched for animation (e.g. shake cards 0.5 secs or something)
      };
    })

    this.state = {
      cardStates: cardStates,
      selectedIdx: -1,           // first (last) selected card state
      rounds: 0,
      matches: 0,
      misses: 0,           // same as =>  pairs - matches
      pairs: cardStates.length / 2,
      locked: false,       // while locked do NOT allow any clicks
      gameOver: false     // same as =>  matches == pairs
    };
  }


  onClickCard( idx ) {
     console.log( "onClickCard idx:" + idx );

     if( this.state.locked )   // board locked
       return;

     var cardStates  = this.state.cardStates,
         cardState   = cardStates[idx],         // current clicked card
         selectedIdx = this.state.selectedIdx,  // last/prev clicked card
         selected    = selectedIdx == -1 ? null : cardStates[selectedIdx];

     console.log( "cardState:" );
     console.log( cardState );
     console.log( "selected cardState:");
     console.log( selected );

     if( selectedIdx === idx || cardState.matched === true )
       return;

     // todo: make a deep clone copy of cardStates - why? why not??

     cardState.flipped = !cardState.flipped;
     this.setState( { cardStates: this.state.cardStates } );

     if( selected ) {   // second selection; check for matching pairs

        if( selected.num == cardState.num ) {  // bingo! a matching card pair
           selected.matched  = true;
           cardState.matched = true;

           this.setState( { cardStates:  this.state.cardStates,
                            selectedIdx:  -1,
                            matches:     this.state.matches+1,
                            rounds:      this.state.rounds+1 } );
        }
        else {
           this.setState( { locked: true } );  // do NOT allow more clicks while waiting for auto-unflip

           setTimeout( ()=>{
             selected.flipped  = false;
             cardState.flipped = false;

             this.setState( { cardStates: this.state.cardStates,
                              selectedIdx:  -1,
                              misses:      this.state.misses+1,
                              rounds:      this.state.rounds+1,
                              locked:     false
                            })}, 1000 );    // auto-unflipp; wait 1 sec
        }
     }
     else {   // first selection
        this.setState( { selectedIdx: idx } );
     }
  } // method onClickCard()


   render() {
     const { cardStates,
             rounds,
             pairs,
             misses,
             matches
           } = this.state;

     return(
<div id="container">
  <h1>Memory Cards Game (4x4) - React Sample</h1>
  <div>
    Stats - Rounds: {rounds},
            Matches: {matches}/{pairs},
            Misses: {misses}
  </div>
  { cardStates.map( (card,idx) => (
      <Card num={card.num} group={card.group}
            flipped={card.flipped}
            matched={card.matched}
            onClick={()=>this.onClickCard(idx)} />
    ))
  }
</div>
     );
   } // method render()
} // class Game

import React from 'react';
import ReactDOM from 'react-dom';


class Card extends React.Component {
  constructor( props ) {
    super( props );
    this.state = { isFlipped: false };
  }

  get backText() { return {
    "A": "?",
    "B": "="
  }};


  get frontTextA() { return {
     1: "1×1",
     2: "2×2",
     3: "3×3",
     4: "4×4",
     5: "5×5",
     6: "6x6",
     7: "7x7",
     8: "8x8"
  }};

 get frontTextB() { return {
     1: "1",
     2: "4",
     3: "9",
     4: "16",
     5: "25",
     6: "36",
     7: "49",
     8: "56"
  }};


  handleClick(ev) {
    console.log( "click, click" );
    this.setState({
        isFlipped: !this.state.isFlipped
      });
  }

  render() {
    const isA        = this.props.group == 'A';
    const isFlipped  = this.state.isFlipped;
    const frontTextA = this.frontTextA[this.props.num];
    const frontTextB = this.frontTextB[this.props.num];
    const backText   = this.backText[this.props.group];


    const cardClasses =
            "card" + (this.state.isFlipped ? " flipped" : "");

    return(
  <div className={cardClasses} onClick={(e)=>this.handleClick(e)}>
     <div className="card-back">{backText}</div>
          { isA ? (
                   <div className="card-front">{frontTextA}</div>
                  ) : (
                    <div className="card-front">
                       <div>{frontTextB}</div>
                       <div className="hint">{frontTextA}</div>
                    </div>
                  ) }
   </div>
  );
 }
}


class Game extends React.Component {
   render() {
     return(
<div id="container">
  <h1>Hello, world!</h1>
  <Card num="1" group="A" />
  <Card num="2" group="A" />
  <Card num="3" group="A" />
  <Card num="1" group="B" />
  <Card num="2" group="B" />
</div>
     );
   }
}


ReactDOM.render(
  <Game/>,
  document.getElementById('main')
);

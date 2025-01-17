import { html, css, LitElement } from 'lit'
import { customElement, property, query } from 'lit/decorators.js'
import { liveState, liveStateConfig } from 'phx-live-state';

/**
 * An example element.
 *
 * @slot - This element has a slot
 * @csspart button - The button
 */
@customElement('people-list')
@liveState({
  topic: "people:all",
  properties: ['people'],
  events: {
    send: ['add_person']
  },
  provide: {
    scope: window,
    name: 'peopleLiveState'
  }
})
export class TodoListElement extends LitElement {
  /**
   * Copy for the read the docs hint.
   */
  @property()
  people: Array<{ name: string }> | undefined;

  @property()
  @liveStateConfig('url')
  url: string = "foo";

  @property({attribute: 'socket-id'})
  @liveStateConfig('params.socket_id')
  socketId: string = "";
  
  render() {
    return html`
      <div>
        Here is da people
        <ul>
          ${this.people?.map(person => html`<li>${person.name}</li>`)}
        </ul>
        <form @submit=${this.addPerson}>
          <div>
            <label>Name</label>
            <input name="name" />
          </div>
          <button>Save</button>
        </form>
      </div>
    `
  }

  addPerson(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    const person = Object.fromEntries(formData.entries());
    this.dispatchEvent(new CustomEvent('add_person', { detail: { person } }));
  }
}


declare global {
  interface HTMLElementTagNameMap {
    'people-list': TodoListElement
  }
}

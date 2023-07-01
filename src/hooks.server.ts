import { error } from '@sveltejs/kit';

export const handle = async ({ event, resolve }) => {
	return resolve(event);
};
